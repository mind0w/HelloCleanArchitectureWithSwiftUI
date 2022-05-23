//
//  ModifyServiceTests.swift
//
//
//  Created by mindw on 2022/05/20.
//

import XCTest
import Combine
@testable import DomainLayer

final class ModifyServiceTests: XCTestCase {
    
    var useCase: ModifyServiceUseCase?
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Setup
    
    override func setUpWithError() throws {
        
        self.useCase = ModifyServiceUseCase(repository: FakeServiceRepository())
        
        guard self.useCase != nil else {
            XCTFail("Usecase is nil")
            return
        }
    }
    
    //MARK: - Tests
    func testExecute() {
        
        useCase?.execute(value: .init())
            .sink { receiveCompletion in
                switch receiveCompletion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { success in
                XCTAssertTrue(success)
            }
            .store(in: &bag)
    }

    static var allTests = [
        ("testExecute", testExecute),
    ]
}
