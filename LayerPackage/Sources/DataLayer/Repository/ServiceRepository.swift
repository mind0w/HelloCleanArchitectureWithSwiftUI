//
//  ServiceRepository.swift
//  
//
//  Created by mindw on 2022/01/03.
//

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
    
    public func modifyService(_ service: ServiceModel) -> AnyPublisher<Bool, Never> {
        return Just(service)
            .asyncMap { await dataSource.modifyService($0) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
