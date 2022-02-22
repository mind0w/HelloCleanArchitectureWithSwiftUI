//
//  TokenViewModelTests.swift
//  
//
//  Created by mindw on 2022/01/10.
//

import XCTest
import Combine
@testable import DomainLayer
@testable import PresentationLayer

class TokenViewModelTests: XCTestCase {
    
    var viewModel: TokenViewModel?
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()

    override func setUpWithError() throws {
        let fetchServiceUseCase = FetchServiceListUseCase(repository: FakeServiceRepository())
        let insertServiceUseCase = InsertServiceUseCase(repository: FakeServiceRepository())
        viewModel = TokenViewModel(fetchListUseCase: fetchServiceUseCase, insertServiceUseCase: insertServiceUseCase)
        
        guard viewModel != nil else {
            XCTFail("ViewModel is nil")
            return
        }
    }

    func testInsert() {
        let expectation = XCTestExpectation(description: self.description)
        let serviceName = "Google"
        let addtionalInfo = "sample@google.com"
        let sercretKey = "123"
        
        viewModel?.$services
            .sink(receiveValue: { services in
                guard let service = services.last else {
                    return
                }
                XCTAssertNotNil(service)
                XCTAssertNotNil(service.id)
                XCTAssertEqual(service.serviceName, serviceName)
                XCTAssertEqual(service.additinalInfo, addtionalInfo)
                expectation.fulfill()
            })
            .store(in: &bag)
        
        viewModel?.executeInsertService(serviceName: serviceName,
                                        secretKey: sercretKey,
                                        additionalInfo: addtionalInfo)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchList() {
        
        let expectation = XCTestExpectation(description: self.description)
        
        viewModel?.$services
            .sink(receiveValue: { services in
                guard services.count > 0 else {
                    return
                }
                XCTAssertNotNil(services)
                for service in services {
                    XCTAssertNotNil(service.id)
                    XCTAssertNotNil(service.serviceName)
                }
                
                expectation.fulfill()
            })
            .store(in: &bag)
        
        viewModel?.executeFetchList()
        
        wait(for: [expectation], timeout: 1)
    }
    
    static var allTests = [
        ("testInsert", testInsert),
        ("testFetchList", testFetchList),
    ]

}
