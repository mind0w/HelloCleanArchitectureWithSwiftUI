//
//  TokenDetailView.swift
//  
//
//  Created by mindw on 2022/05/20.
//

import SwiftUI
import DomainLayer

struct TokenDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    
    @State var serviceName = ""
    @State var additionalInfo = ""
    
    private let viewModel: TokenViewModel
    private let service: ServiceModel
    
    public init(viewModel: TokenViewModel, service: ServiceModel) {
        self.viewModel = viewModel
        self.service = service
        _serviceName = State(initialValue: service.serviceName ?? "")
        _additionalInfo = State(initialValue: service.additionalInfo ?? "")
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Service name")
            TextField("Service name", text: $serviceName)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 16)
            
            Text("Additional info")
            TextField("Additional info", text: $additionalInfo)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Edit")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(UIColor.label))
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    self.viewModel.executeEditService(id: service.id, serviceName: serviceName, additionalInfo: additionalInfo) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Done")
                        .foregroundColor(Color(UIColor.label))
                }
            }
        }
    }
}

struct TokenDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TokenDetailView(viewModel: .init(), service: .init())
            .environmentObject(AppState())
    }
}
