//
//  FetchServiceListUseCase.swift
//  
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import Combine


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
