//
//  AppDI.swift
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import DataLayer
import DomainLayer
import PresentationLayer

enum PHASE {
    case DEV, ALPHA, REAL
}

public struct AppEnvironment {
    let phase: PHASE = .DEV
}

public class AppDI: AppDIInterface {

    static let shared = AppDI(appEnvironment: AppEnvironment())

    private let appEnvironment: AppEnvironment

    private init(appEnvironment: AppEnvironment) {
        self.appEnvironment = appEnvironment
    }

    private lazy var serviceRepository: ServiceRepositoryInterface = {
        let dataSource: ServiceDataSourceInterface

        switch appEnvironment.phase {
        case .DEV:
            dataSource = ServiceMockDataSource()
        default:
            dataSource = ServiceMockDataSource()
        }

        return ServiceRepository(dataSource: dataSource)
    }()
    
    public lazy var tokenViewModel: TokenViewModel = {
        return .init(fetchListUseCase: .init(repository: serviceRepository),
                     insertServiceUseCase: .init(repository: serviceRepository),
                     modifyServiceUseCase: .init(repository: serviceRepository))
    }()
}
