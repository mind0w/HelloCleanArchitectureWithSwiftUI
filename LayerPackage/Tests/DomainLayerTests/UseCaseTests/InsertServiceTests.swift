//
//  InsertServiceTests.swift
//  
//
//  Created by mindw on 2022/01/10.
//

import XCTest
import Combine
@testable import DomainLayer

class InsertServiceTests: XCTestCase {

    var useCase: InsertServiceUseCase?
    private var bag = Set<AnyCancellable>()

    override func setUpWithError() throws {
        self.useCase = InsertServiceUseCase(repository: FakeServiceRepository())

        guard self.useCase != nil else {
            XCTFail("InsertServiceUseCase is nil")
            return
        }
    }

    func testExecute() {
        let req = InsertServiceRequestValue(serviceName: "Google",
                                            secretKey: "123",
                                            additionalInfo: "sample@google.com")
        self.useCase?.execute(value: req)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    XCTFail(err.localizedDescription)
                    break
                }
            } receiveValue: { service in
                XCTAssertNotNil(service)
                XCTAssertNotNil(service.id)
                XCTAssertEqual(service.serviceName, req.serviceName)
                XCTAssertEqual(service.additinalInfo, req.additionalInfo)
            }
            .store(in: &bag)

    }
    
    static var allTests = [
        ("testExecute", testExecute),
    ]
}
