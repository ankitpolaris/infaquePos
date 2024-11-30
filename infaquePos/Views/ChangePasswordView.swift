//
//  ChangePasswordView.swift
//  infaquePos
//
//  Created by Ankit Khanna on 28/11/24.
//

import SwiftUI
import FirebaseAuth


struct ChangePasswordView: View {
    @Binding var isPresented: Bool // Binding to dismiss the sheet

    
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isSuccess: Bool = false
    @StateObject private var viewModel = AuthViewModel()
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Change Password")
                .font(.title)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                Text("Current Password")
                    .font(.headline)
                    .foregroundColor(.primary)
                TextField("Current Password", text: $currentPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 5)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("New Password")
                    .font(.headline)
                    .foregroundColor(.primary)
                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 5)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Confirm New Password")
                    .font(.headline)
                    .foregroundColor(.primary)
                SecureField("Confirm New Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 5)
            }
            .padding(.horizontal)
            Spacer()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if isSuccess {
                Text("Password changed successfully!")
                    .foregroundColor(.green)
                    .padding()
            }
            
            Button(action: {
                viewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword) { result in
                    isSuccess = true
                    //                isPresented = false
                }
                
            }) {
                Text("Change Password")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}


struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a state variable to control the presentation in the preview
        ChangePasswordView(isPresented: .constant(true))
    }
}

