//
//  TokenViewModel.swift
//
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import Combine
import DomainLayer

public protocol TokenViewModelInput {
    func executeFetchList()
    func executeInsertService(serviceName: String?, secretKey: String?, additionalInfo: String?)
    func executeEditService(id: Int64, serviceName: String?, additionalInfo: String?, completion: (() -> Void)?)
}

public protocol TokenViewModelOutput {
    var services: [ServiceModel] { get }
}

public final class TokenViewModel: ObservableObject, TokenViewModelInput, TokenViewModelOutput {
    @Published public var services = [ServiceModel]()
    
    private let fetchListUseCase: FetchServiceListUseCase?
    private let insertServiceUseCase: InsertServiceUseCase?
    private let modifyServiceUseCase: ModifyServiceUseCase?
    
    private var bag = Set<AnyCancellable>()
    
    public init(fetchListUseCase: FetchServiceListUseCase? = nil,
                insertServiceUseCase: InsertServiceUseCase? = nil,
                modifyServiceUseCase: ModifyServiceUseCase? = nil) {
        self.fetchListUseCase = fetchListUseCase
        self.insertServiceUseCase = insertServiceUseCase
        self.modifyServiceUseCase = modifyServiceUseCase
    }
    
    public func executeFetchList() {
        self.fetchListUseCase?.execute(value: ())
            .assign(to: \.services, on: self)
            .store(in: &bag)
    }
    
    public func executeInsertService(serviceName: String?, secretKey: String?, additionalInfo: String?) {
        self.insertServiceUseCase?.execute(value: InsertServiceRequestValue(serviceName: serviceName,
                                                                            secretKey: secretKey,
                                                                            additionalInfo: additionalInfo))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }, receiveValue: { service in
                self.services.append(service)
            })
            .store(in: &bag)
    }
    
    public func executeEditService(id: Int64,
                                   serviceName: String? = nil,
                                   additionalInfo: String? = nil,
                                   completion: (() -> Void)? = nil) {
        var req = ServiceModel(id: id)
        req.serviceName = serviceName
        req.additionalInfo = additionalInfo
        self.modifyServiceUseCase?.execute(value: req)
            .sink(receiveValue: { success in
                if success, let idx = self.services.firstIndex(where: { $0.id == id }) {
                    self.services[idx].serviceName = serviceName
                    self.services[idx].additionalInfo = additionalInfo
                }
                completion?()
            })
            .store(in: &bag)
    }
}
