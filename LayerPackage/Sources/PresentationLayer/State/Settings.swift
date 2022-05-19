//
//  Settings.swift
//
//
//  Created by mindw on 2022/05/19.
//

import Foundation
import SwiftUI

private enum AppStorageKey: String {
    /// 테마
    case theme
}

public class Settings: ObservableObject {
    
    @AppStorage(AppStorageKey.theme.rawValue)
    public var theme = ThemeType.light

    public init() {}
}

public enum ThemeType: String, CaseIterable {
    case auto = "Auto System setting"
    case light = "Light"
    case dark = "Dark"
}
