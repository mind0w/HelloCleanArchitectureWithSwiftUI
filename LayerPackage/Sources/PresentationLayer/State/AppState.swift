//
//  AppState.swift
//  
//
//  Created by mindw on 2022/05/19.
//

import Foundation
import Combine

public class AppState: ObservableObject {
    @Published var settings: Settings
    
    var settingCancellable: AnyCancellable?

    public init(settings: Settings = Settings()) {
        self.settings = settings

        settingCancellable = settings.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
            })
    }
}
