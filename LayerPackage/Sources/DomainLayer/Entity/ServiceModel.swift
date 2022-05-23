//
//  ServiceModel.swift
//
//
//  Created by mindw on 2022/01/03.
//

import Foundation

public struct ServiceModel: Identifiable {
    public var id: Int64 = 0
    public var otpCode: String?
    public var serviceName: String?
    public var additionalInfo: String?
    public var period: Int
    
    public init(id: Int64 = 0,
                otpCode: String? = nil,
                serviceName: String? = nil,
                additionalInfo: String? = nil,
                period: Int = 30) {
        self.id = id
        self.otpCode = otpCode
        self.serviceName = serviceName
        self.additionalInfo = additionalInfo
        self.period = period
    }
}
