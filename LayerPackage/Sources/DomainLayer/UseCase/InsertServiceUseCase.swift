//
//  InsertServiceUseCase.swift
//
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import Combine

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
