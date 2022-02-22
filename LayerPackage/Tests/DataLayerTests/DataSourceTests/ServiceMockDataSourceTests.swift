//
//  ServiceMockDataSourceTests.swift
//  
//
//  Created by mindw on 2022/01/10.
//

import XCTest
@testable import DataLayer
@testable import DomainLayer

class ServiceMockDataSourceTests: XCTestCase {

    var dataSource: ServiceMockDataSource?
    
    override func setUpWithError() throws {
        dataSource = ServiceMockDataSource()
        
        guard dataSource != nil else {
            XCTFail("DataSource is nil")
            return
        }
    }
    
    func testInsert() {
        Task {
            let req = InsertServiceRequestValue(serviceName: "Google",
                                                secretKey: "123",
                                                additionalInfo: "sample@google.com")
            let service = try await dataSource?.insertService(value: req)
            
            XCTAssertNotNil(service)
            XCTAssertNotNil(service!.id)
            XCTAssertEqual(service!.serviceName, req.serviceName)
            XCTAssertEqual(service!.additinalInfo, req.additionalInfo)
        }
    }
    
    func testFetchList() {
        Task {
            let services = await dataSource?.fetchServiceList()
            XCTAssertNotNil(services)
            XCTAssertGreaterThan(services!.count, 0)
            for service in services! {
                XCTAssertNotNil(service.id)
                XCTAssertNotNil(service.serviceName)
                XCTAssertNotNil(service.additinalInfo)
                XCTAssertNotNil(service.otpCode)
            }
        }
    }
    
    static var allTests = [
        ("testInsert", testInsert),
        ("testFetchList", testFetchList),
    ]
}
