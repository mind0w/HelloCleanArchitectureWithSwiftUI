//
//  AppDIInterface.swift
//  
//
//  Created by mindw on 2022/01/03.
//

import Foundation
import DomainLayer

public protocol AppDIInterface {
    var tokenViewModel: TokenViewModel { get }
}

public class MockDI: AppDIInterface {
    public var tokenViewModel = TokenViewModel()
    
    public init() {
        
    }
}
