//
//  ServiceMockDataSource.swift
//  
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import Combine
import DomainLayer

public protocol ServiceDataSourceInterface {
    func insertService(value: InsertServiceRequestValue) async throws -> ServiceModel
    func fetchServiceList() async -> [ServiceModel]
}

public final actor ServiceMockDataSource {
    // 테스트 데이터
    var mockDatas: [ServiceModel] = [
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
        
        self.mockDatas.append(insertData)
        
        return insertData
    }
    
    public func fetchServiceList() async -> [ServiceModel] {
        return mockDatas
    }

}
