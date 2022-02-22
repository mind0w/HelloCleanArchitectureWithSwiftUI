//
//  ServiceRepositoryTests.swift
//  
//
//  Created by mindw on 2022/01/10.
//

import XCTest
import Combine
@testable import DataLayer
@testable import DomainLayer

class ServiceRepositoryTests: XCTestCase {

    var repository: ServiceRepository?
    private var bag = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        repository = ServiceRepository(dataSource: ServiceMockDataSource())
        
        guard repository != nil else {
            XCTFail("Repository is nil")
            return
        }
    }
    
    func testInsert() {
        let req = InsertServiceRequestValue(serviceName: "Google",
                                            secretKey: "123",
                                            additionalInfo: "sample@google.com")
        
        repository?.insertService(value: req)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    XCTFail(err.localizedDescription)
                    break
                }
            }, receiveValue: { service in
                XCTAssertNotNil(service)
                XCTAssertNotNil(service.id)
                XCTAssertEqual(service.serviceName, req.serviceName)
                XCTAssertEqual(service.additinalInfo, req.additionalInfo)
            })
            .store(in: &bag)
    }
    
    func testFetchList() {
        repository?.fetchServiceList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    XCTFail(err.localizedDescription)
                    break
                }
            }, receiveValue: { services in
                XCTAssertGreaterThan(services.count, 0)
                for service in services {
                    XCTAssertNotNil(service.id)
                    XCTAssertNotNil(service.serviceName)
                    XCTAssertNotNil(service.additinalInfo)
                    XCTAssertNotNil(service.otpCode)
                }
            })
            .store(in: &bag)
    }
    
    static var allTests = [
        ("testInsert", testInsert),
        ("testFetchList", testFetchList),
    ]
}
