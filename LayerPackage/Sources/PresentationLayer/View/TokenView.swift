//
//  TokenView.swift
//  
//
//  Created by mindw on 2022/01/03.
//

import SwiftUI
import DomainLayer

public struct TokenView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject var appState: AppState
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
                    HStack {
                        Button {
                            self.appState.settings.theme = (self.appState.settings.theme == .light) ? .dark : .light
                        } label: {
                            Image(systemName: "paintpalette.fill")
                                .foregroundColor(Color(UIColor.label))
                        }
                    
                        Button {
                            self.viewModel.executeInsertService(serviceName: "Token",
                                                                secretKey: "123",
                                                                additionalInfo: "insert@test.com")
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(Color(UIColor.label))
                        }
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.executeFetchList()
        }
        .environment(\.colorScheme, theme)
    }
    
    private var theme: ColorScheme {
        switch self.appState.settings.theme {
        case .auto:
            return self.colorScheme
        case .light:
            return .light
        case .dark:
            return .dark
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
            .environmentObject(AppState())
    }
}
#endif
