//
//  TokenView.swift
//  
//
//  Created by mindw on 2022/01/03.
//

import SwiftUI
import DomainLayer

public struct TokenView: View {
    @ObservedObject var viewModel: TokenViewModel
    
    public init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(self.viewModel.services) { service in
                    VStack(alignment: .leading) {
                        Text(service.serviceName ?? "")
                        Text(service.otpCode ?? "")
                            .font(.title)
                            .bold()
                        Text(service.additinalInfo ?? "")
                    }
                    .padding()
                }
            }
            .navigationTitle("Tokens")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Insert") {
                        self.viewModel.executeInsertService(serviceName: "Token",
                                                            secretKey: "123",
                                                            additionalInfo: "insert@test.com")
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.executeFetchList()
        }
    }
}

#if DEBUG
struct TokenView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = TokenViewModel()
        vm.services.append(ServiceModel(id: 0, otpCode: "000 000", serviceName: "Name0", additinalInfo: "Info0"))
        vm.services.append(ServiceModel(id: 1, otpCode: "111 111", serviceName: "Name1", additinalInfo: "Info1"))
        return TokenView(viewModel: vm)
    }
}
#endif
