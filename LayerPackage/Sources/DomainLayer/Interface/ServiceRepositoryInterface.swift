//
//  ServiceRepositoryInterface.swift
//
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import Combine

public protocol ServiceRepositoryInterface {
    func insertService(value: InsertServiceRequestValue) -> AnyPublisher<ServiceModel, Error>
    func fetchServiceList() -> AnyPublisher<[ServiceModel], Never>
}
