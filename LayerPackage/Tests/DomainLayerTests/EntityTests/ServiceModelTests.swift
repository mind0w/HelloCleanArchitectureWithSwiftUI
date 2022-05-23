//
//  WeatherEntityTests.swift
//  
//
//  Created by mindw on 2021/02/12.
//

import XCTest
@testable import DomainLayer

final class ServiceModelTests: XCTestCase {
    
    //MARK: - Setup
    
    override func setUpWithError() throws {
    }
    
    //MARK: - Tests
    
    func testExecute() {
        
        let serviceModel = ServiceModel(id: 123,
                                        otpCode: "123 123",
                                        serviceName: "Google",
                                        additionalInfo: "test@google.com")
        
        XCTAssertNotNil(serviceModel)
        XCTAssertEqual(serviceModel.id, 123)
    }

    static var allTests = [
        ("testExecute", testExecute),
    ]
}
