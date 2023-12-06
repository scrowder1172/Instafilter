//
//  ConfirmationDialogExampleView.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/6/23.
//

import SwiftUI

struct ConfirmationDialogExampleView: View {
    
    @State private var showingAlert: Bool = false
    @State private var showingConfirmationDialog: Bool = false
    
    var body: some View {
        VStack {
            Button("Show Alert Message") {
                showingAlert.toggle()
            }
            .frame(width: 250, height: 50)
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.vertical, 40)
            
            Button("Show Confirmation Dialog") {
                showingConfirmationDialog.toggle()
            }
            .frame(width: 250, height: 50)
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.vertical, 40)
        }
        .alert("Alert Message", isPresented: $showingAlert) {
            Button("OK") {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This is an alert message")
        }
        .confirmationDialog("Confirmation Dialog", isPresented: $showingConfirmationDialog) {
            Button("OK") {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This is a dialog screen")
        }
        
    }
}

#Preview {
    ConfirmationDialogExampleView()
}
