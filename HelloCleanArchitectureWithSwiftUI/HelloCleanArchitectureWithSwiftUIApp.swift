//
//  HelloCleanArchitectureWithSwiftUIApp.swift
//  HelloCleanArchitectureWithSwiftUI
//
//  Created by mindw on 2022/02/22.
//

import SwiftUI
import PresentationLayer

@main
struct HelloCleanArchitectureWithSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TokenView(viewModel: AppDI.shared.tokenViewModel)
        }
    }
}