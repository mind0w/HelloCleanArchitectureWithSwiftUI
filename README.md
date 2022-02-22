# HelloCleanArchitectureWithSwiftUI
CleanArchitecture for SwiftUI with Combine, Concurrency

## 개요
Clean Architecture를 SwiftUI와 Combine을 사용한 iOS 프로젝트에 적용한 예제

<img width="564" alt="image" src="https://user-images.githubusercontent.com/25020477/155071436-2a37cde9-0da7-4521-8dac-3af22f25021b.png">


## Layer와 Data Flow
먼저 역할별 레이어들부터 알아보자면 다음과 같다.
* Presentation Layer: UI 관련 레이어
* Domain Layer: 비즈니스 룰과 로직 담당 레이어
* Data Layer: 원격/로컬등 외부에서 데이터를 가져오는 레이어

![image](https://user-images.githubusercontent.com/25020477/155071101-28765b74-9c9a-4ccb-ae19-f342288937c0.png)

* 각 레이어들의 Dependency 방향은 모두 원밖에서 원안쪽으로 향하고 있음
* UI를 담당하는 Presentation Layer는 MVVM 패턴으로 구현됨


각 레이어의 데이터 흐름은 다음과 같다.

![image](https://user-images.githubusercontent.com/25020477/155071125-fab08a92-4501-4bfe-916e-ac19ce549f90.png)

* Domain Layer에서 Data Layer를 실행 시킬 수 있는 이유는 Dependency Inversion 으로 구현되었기 때문

> Dependency Inversion 이란?
>
> 각 모듈간의 의존성을 분리시키기 위해 추상화된 인터페이스만 제공하고 의존성은 외부에서 주입(Dependency Injection)시킴

 
 
## 프로젝트 구성 (Swift Package Manager)
Clean Architecture의 각 Layer 별 의존성을 구현하기 위해 SPM을 사용하여 프로젝트를 구성한다.

* 로컬 패키지를 하나 추가하고 폴더 구조를 다음과 같이 구성한다.

  <img width="329" alt="image" src="https://user-images.githubusercontent.com/25020477/155071282-897c8d42-6d2d-4b09-aa68-95236a944c5c.png">

* LayerPackage/Package.swift 에서 다음과 같이 Dependency를 줄 수 있음

``` swift
import PackageDescription

let package = Package(
    name: "LayerPackage",
    platforms: [.iOS(.v15), .macOS("12")],
    products: [
        .library(
            name: "LayerPackage",
            targets: ["DataLayer", "DomainLayer", "PresentationLayer"]),
        
    ],
    dependencies: [
    ],
    targets: [
        
        //MARK: - Data Layer
        // Dependency Inversion : UseCase(DomainLayer) <- Repository <-> DataSource
        .target(
            name: "DataLayer",
            dependencies: ["DomainLayer"]),
        
        //MARK: - Domain Layer
        .target(
            name: "DomainLayer",
            dependencies: []),
        
        //MARK: - Presentation Layer (MVVM)
        // Dependency : View -> ViewModel -> Model(DomainLayer)
        .target(
            name: "PresentationLayer",
            dependencies: ["DomainLayer"]),
                        
        //MARK: - Tests
        .testTarget(
            name: "DataLayerTests",
            dependencies: ["DataLayer"]),
        
        .testTarget(
            name: "DomainLayerTests",
            dependencies: ["DomainLayer"]),
    
        .testTarget(
            name: "PresentationLayerTests",
            dependencies: ["PresentationLayer"]),
    ]
)
```

 
## Domain Layer 구현
* 원의 가장 내부 계층이며 핵심 기능을 담당하는 데이터 구조
* 상위 계층에 의존성을 갖고 있지 않음으로 독립적으로 수행 가능해야 함

``` swift
public struct ServiceModel: Identifiable {
    public var id: Int64 = 0
    public var otpCode: String?
    public var serviceName: String?
    public var additinalInfo: String?
    public var period: Int
    
    public init(id: Int64 = 0,
                otpCode: String? = nil,
                serviceName: String? = nil,
                additinalInfo: String? = nil,
                period: Int = 30) {
        self.id = id
        self.otpCode = otpCode
        self.serviceName = serviceName
        self.additinalInfo = additinalInfo
        self.period = period
    }
}
```

* Data Layer에서 구현될 Repository에 대한 인터페이스를 추상화 함으로써 Dependency Inversion 구현을 가능하도록 함 

``` swift
import Combine

public protocol ServiceRepositoryInterface {
    func insertService(value: InsertServiceRequestValue) -> AnyPublisher<ServiceModel, Error>
    func fetchServiceList() -> AnyPublisher<[ServiceModel], Never>
}
```

* 비즈니스 로직에 대한 각 UseCase를 구현
* ServiceUseCase는 associatedtype을 활용한 UseCase 프로토콜

``` swift
protocol ServiceUseCase {
    associatedtype RequestValue
    associatedtype ResponseValue
    var repository: ServiceRepositoryInterface { get }
    
    init(repository: ServiceRepositoryInterface)
    func execute(value: RequestValue) -> ResponseValue
}
```
``` swift
public struct FetchServiceListUseCase: ServiceUseCase {
    typealias RequestValue = Void
    typealias ResponseValue = AnyPublisher<[ServiceModel], Never>
    let repository: ServiceRepositoryInterface
    
    public init(repository: ServiceRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(value: Void) -> AnyPublisher<[ServiceModel], Never> {
        return repository.fetchServiceList()
    }
}
```
``` swift
public struct InsertServiceRequestValue {
    public let serviceName: String?
    public let secretKey: String?
    public let additionalInfo: String?
    
    public init(serviceName: String? = nil,
                secretKey: String? = nil,
                additionalInfo: String? = nil) {
        self.serviceName = serviceName
        self.secretKey = secretKey
        self.additionalInfo = additionalInfo
    }
}

public struct InsertServiceUseCase: ServiceUseCase {
    typealias RequestValue = InsertServiceRequestValue
    typealias ResponseValue = AnyPublisher<ServiceModel, Error>
    let repository: ServiceRepositoryInterface
    
    public init(repository: ServiceRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(value: InsertServiceRequestValue) -> AnyPublisher<ServiceModel, Error> {
        return repository.insertService(value: value)
    }
}
```

## Presentation Layer 구현
* UI 를 담당하는 Layer
* MVVM 패턴으로 구현
* View와 ViewModel 사이는 Combine으로 Data Binding 처리

``` swift
import Foundation
import Combine
import DomainLayer

public protocol TokenViewModelInput {
    func executeFetchList()
    func executeInsertService(serviceName: String?,
                              secretKey: String?,
                              additionalInfo: String?)
}

public protocol TokenViewModelOutput {
    var services: [ServiceModel] { get }
}

public final class TokenViewModel: ObservableObject, TokenViewModelInput, TokenViewModelOutput {
    @Published public var services = [ServiceModel]()
    
    private let fetchListUseCase: FetchServiceListUseCase?
    private let insertServiceUseCase: InsertServiceUseCase?
    
    private var bag = Set<AnyCancellable>()
    
    public init(fetchListUseCase: FetchServiceListUseCase? = nil,
                insertServiceUseCase: InsertServiceUseCase? = nil) {
        self.fetchListUseCase = fetchListUseCase
        self.insertServiceUseCase = insertServiceUseCase
    }
    
    public func executeFetchList() {
        self.fetchListUseCase?.execute(value: ())
            .assign(to: \.services, on: self)
            .store(in: &bag)
    }
    
    public func executeInsertService(serviceName: String?,
                                     secretKey: String?,
                                     additionalInfo: String?) {
        
        let value = InsertServiceRequestValue(serviceName: serviceName,
                                              secretKey: secretKey,
                                              additionalInfo: additionalInfo)
        self.insertServiceUseCase?.execute(value: value)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }, receiveValue: { service in
                self.services.append(service)
            })
            .store(in: &bag)
    }
}
```

* ObservableObject로 구현
* Domain Layer에 대한 의존성

 
List로 service를 보여줄 TokenView 작성

``` swift
import SwiftUI
import DomainLayer

public struct TokenView: View {
    //1
    @ObservedObject var viewModel: TokenViewModel
    
    public init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            List {
                //1
                ForEach(self.viewModel.services) { service in
                    VStack(alignment: .leading) {
                        Text(service.serviceName ?? "")
                        Text(service.otpCode ?? "")
                            .font(.title)
                            .bold()
                        Text(service.additinalInfo ?? "")
                    }
                    .padding()
                }
            }
            .navigationTitle("Tokens")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Insert") {
                        //2
                        self.viewModel.executeInsertService(serviceName: "Token",
                                                            secretKey: "123",
                                                            additionalInfo: "insert@test.com")
                    }
                }
            }
        }
        .onAppear {
            //3
            self.viewModel.executeFetchList()
        }
    }
}
```
1. ObservedObject로 선언된 ViewModel 내의 데이터가 업데이트되면 화면이 갱신됨
1. Insert 버튼 누르면 ViewModel의 insert UseCase를 실행
1. 화면이 보일때 ViewModel의 fetch list UseCase를 실행



## Data Layer 구현
* DB, Network 등 내/외부 데이터를 사용하는 Layer
* DataSource는 비동기로 동작하기 위해 [Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html) 로 구현
* mocked data로 구현, data race를 방지하기 위해 actor 사용

``` swift
import Foundation
import DomainLayer

public protocol ServiceDataSourceInterface {
    func insertService(value: InsertServiceRequestValue) async throws -> ServiceModel
    func fetchServiceList() async -> [ServiceModel]
}

public final actor ServiceMockDataSource {
    // 테스트 데이터
    var mockData: [ServiceModel] = [
        ServiceModel(id: 0, otpCode: "123 123", serviceName: "Google", additinalInfo: "sample@google.com"),
        ServiceModel(id: 1, otpCode: "456 456", serviceName: "Github", additinalInfo: "sample@github.com"),
        ServiceModel(id: 2, otpCode: "789 789", serviceName: "Amazon", additinalInfo: "sample@amazon.com")
    ]
    
    public init() {}
}

extension ServiceMockDataSource: ServiceDataSourceInterface {
    
    public func insertService(value: InsertServiceRequestValue) async throws -> ServiceModel {
        guard let serviceName = value.serviceName else { throw ServiceError.unknown }
        
        let insertData = ServiceModel(id: Int64.random(in: 0..<Int64.max),
                                      otpCode: "123 456",
                                      serviceName: serviceName,
                                      additinalInfo: value.additionalInfo ?? "")
        
        self.mockData.append(insertData)
        
        return insertData
    }
    
    public func fetchServiceList() async -> [ServiceModel] {
        return mockData
    }

}
```

* Combine operator에서 concurrency 호출을 위해 Future를 래핑하여 사용

``` swift
import Combine

extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
    
    func tryAsyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Future<T, Error>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}

```

* Domain Layer의 Repository Interface를 구현하여 Dependency Inversion을 완성

``` swift
import Foundation
import Combine
import DomainLayer

public struct ServiceRepository: ServiceRepositoryInterface {
    
    private let dataSource: ServiceDataSourceInterface
    
    public init(dataSource: ServiceDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    public func insertService(value: InsertServiceRequestValue) -> AnyPublisher<ServiceModel, Error> {
        return Just(value)
            .setFailureType(to: Error.self)
            .tryAsyncMap { try await dataSource.insertService(value: $0) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
        
    public func fetchServiceList() -> AnyPublisher<[ServiceModel], Never> {
        return Just(())
            .asyncMap { await dataSource.fetchServiceList() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
```
 

## Dependency Injection 구현
* 앱의 진입점에서 의존성 주입 및 환경 설정


  ![image](https://user-images.githubusercontent.com/25020477/155071395-f0d7b1ec-f644-46f4-9b5b-2a9da562655c.png)


* AppDI Interface는 Presentation Layer에 구현

``` swift
public protocol AppDIInterface {
    var tokenViewModel: TokenViewModel { get }
}
```

* AppDI는 모든 DI를 사용하는 컨테이너 역할

``` swift
import Foundation
import DataLayer
import DomainLayer
import PresentationLayer

enum PHASE {
    case DEV, ALPHA, REAL
}

public struct AppEnvironment {
    let phase: PHASE = .DEV
}

public class AppDI: AppDIInterface {

    static let shared = AppDI(appEnvironment: AppEnvironment())

    private let appEnvironment: AppEnvironment

    private init(appEnvironment: AppEnvironment) {
        self.appEnvironment = appEnvironment
    }

    public lazy var tokenViewModel: TokenViewModel = {

        //MARK: Data Layer
        let dataSource: ServiceDataSourceInterface

        switch appEnvironment.phase {
        case .DEV:
            dataSource = ServiceMockDataSource()
        default:
            dataSource = ServiceMockDataSource()
        }

        let repository = ServiceRepository(dataSource: dataSource)

        //MARK: Domain Layer
        let fetchListUseCase = FetchServiceListUseCase(repository: repository)
        let insertServiceUseCase = InsertServiceUseCase(repository: repository)

        //MARK: Presentation
        let viewModel = TokenViewModel(fetchListUseCase: fetchListUseCase,
                                       insertServiceUseCase: insertServiceUseCase)

        return viewModel
    }()
}
```

* 뷰 초기화 시 AppDI를 사용하여 의존성 주입

``` swift
import SwiftUI
import PresentationLayer

@main
struct HelloCleanArchitectureWithSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TokenView(viewModel: AppDI.shared.tokenViewModel)
        }
    }
}
```
  

## References
* [Clean Coder Blog](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
* [Clean Architecture for SwiftUI](https://medium.com/swlh/clean-architecture-for-swiftui-6d6c4eb1cf6a)
* [SwiftUI를 위한 클린 아키텍처](https://gon125.github.io/posts/SwiftUI%EB%A5%BC-%EC%9C%84%ED%95%9C-%ED%81%B4%EB%A6%B0-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98/)
* [[iOS, Swift] Clean Architecture With MVVM on iOS(using SwiftUI, Combine, SPM)](https://tigi44.github.io/ios/iOS,-Swift-Clean-Architecture-with-MVVM-DesignPattern-on-iOS/)
* [[Clean Architecture] iOS Clean Architecture + MVVM 개념과 예제](https://eunjin3786.tistory.com/207)

