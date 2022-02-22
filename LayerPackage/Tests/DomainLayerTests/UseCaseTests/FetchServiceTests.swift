//
//  FetchDailyWeatherUseCaseTests.swift
//  
//
//  Created by tigi on 2021/02/12.
//

import XCTest
import Combine
@testable import DomainLayer

final class FetchServiceTests: XCTestCase {
    
    var useCase: FetchServiceListUseCase?
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Setup
    
    override func setUpWithError() throws {
        
        self.useCase = FetchServiceListUseCase(repository: FakeServiceRepository())
        
        guard self.useCase != nil else {
            XCTFail("Usecase is nil")
            return
        }
    }
    
    //MARK: - Tests
    func testExecute() {
        
        useCase?.execute(value: ())
            .sink { receiveCompletion in
                switch receiveCompletion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { services in
                XCTAssertGreaterThan(services.count, 0)
                for service in services {
                    XCTAssertNotNil(service.id)
                }
            }
            .store(in: &bag)
    }

    static var allTests = [
        ("testExecute", testExecute),
    ]
}
