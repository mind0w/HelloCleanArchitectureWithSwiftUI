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

    public lazy var tokenViewModel: TokenViewModel = {

        //MARK: Data Layer
        let dataSource: ServiceDataSourceInterface

        switch appEnvironment.phase {
        case .DEV:
            dataSource = ServiceMockDataSource()
        default:
            dataSource = ServiceMockDataSource()
        }

        let repository = ServiceRepository(dataSource: dataSource)

        //MARK: Domain Layer
        let fetchListUseCase = FetchServiceListUseCase(repository: repository)
        let insertServiceUseCase = InsertServiceUseCase(repository: repository)

        //MARK: Presentation
        let viewModel = TokenViewModel(fetchListUseCase: fetchListUseCase,
                                       insertServiceUseCase: insertServiceUseCase)

        return viewModel
    }()
}
