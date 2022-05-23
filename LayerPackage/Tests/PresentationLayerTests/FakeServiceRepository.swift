//
//  FakeServiceRepository.swift
//  Tests iOS
//
//  Created by mindw on 2022/01/10.
//

import Foundation
import Combine
@testable import DomainLayer

struct FakeServiceRepository: ServiceRepositoryInterface {
    func insertService(value: InsertServiceRequestValue) -> AnyPublisher<ServiceModel, Error> {
        return Just(ServiceModel(id: 0,
                                 otpCode: value.secretKey,
                                 serviceName: value.serviceName,
                                 additionalInfo: value.additionalInfo))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchServiceList() -> AnyPublisher<[ServiceModel], Never> {

        let mockedList = [
            ServiceModel(id: 0, serviceName: "0"),
            ServiceModel(id: 1, serviceName: "1"),
            ServiceModel(id: 2, serviceName: "2"),
            ServiceModel(id: 3, serviceName: "3"),
            ServiceModel(id: 4, serviceName: "4")
        ]

        return Just(mockedList)
            .eraseToAnyPublisher()
    }
    
    func modifyService(_ service: ServiceModel) -> AnyPublisher<Bool, Never> {
        return Just(true).eraseToAnyPublisher()
    }
}
