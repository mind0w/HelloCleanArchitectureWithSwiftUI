//
//  ServiceUseCase.swift
//
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import Combine

protocol ServiceUseCase {
    associatedtype RequestValue
    associatedtype ResponseValue
    var repository: ServiceRepositoryInterface { get }
    
    init(repository: ServiceRepositoryInterface)
    func execute(value: RequestValue) -> ResponseValue
}
