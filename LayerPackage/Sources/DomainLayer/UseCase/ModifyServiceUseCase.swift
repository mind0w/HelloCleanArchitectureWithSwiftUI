//
//  ModifyServiceUseCase.swift
//  
//
//  Created by mindw on 2022/05/20.
//

import Foundation
import Combine


public struct ModifyServiceUseCase: ServiceUseCase {
    typealias RequestValue = ServiceModel
    typealias ResponseValue = AnyPublisher<Bool, Never>
    let repository: ServiceRepositoryInterface
    
    public init(repository: ServiceRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(value: ServiceModel) -> AnyPublisher<Bool, Never> {
        return repository.modifyService(value)
    }
}
