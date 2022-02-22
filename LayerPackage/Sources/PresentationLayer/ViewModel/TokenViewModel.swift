//
//  TokenViewModel.swift
//
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import Combine
import DomainLayer

public protocol TokenViewModelInput {
    func executeFetchList()
    func executeInsertService(serviceName: String?, secretKey: String?, additionalInfo: String?)
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
    
    public func executeInsertService(serviceName: String?, secretKey: String?, additionalInfo: String?) {
        self.insertServiceUseCase?.execute(value: InsertServiceRequestValue(serviceName: serviceName,
                                                                            secretKey: secretKey,
                                                                            additionalInfo: additionalInfo))
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
