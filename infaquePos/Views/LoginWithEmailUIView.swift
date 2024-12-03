//
//  LoginWithEmailUIView.swift
//  infaquePos
//
//  Created by Ankit Khanna on 27/11/24.
//

import SwiftUI

struct LoginWithEmailUIView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    var loginRequestModel = LoginValidationViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showError = false
    
    @State private var statusMessage: String = ""
    @State private var isLoggedIn: Bool = false
    //    @State private var currentUser: User?
    @FocusState private var focusedField: Field?
    @State private var navigateToHomeTabBarView = false
    
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    
                    Image("brandLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: UIScreen.main.bounds.height / 4)
                        .padding(.bottom, 20)
                    
                    // Email TextField
                    TextField("Email", text: $email)
                        .padding()
                        .frame(height: 50) // Adjust height for a more prominent look
                        .background(
                            Color.white // Background color for prominence
                                .cornerRadius(10.0) // Rounded corners for aesthetics
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(
                                    focusedField == .email ? Color("InfaqueColors") : Color.gray.opacity(0.5),
                                    lineWidth: 2
                                )
                        )
                        .padding(.horizontal, 20)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.bottom, 20)
                    
                    // Password SecureField
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(height: 50) // Adjust height for a more prominent look
                        .background(
                            Color.white // Background color for prominence
                                .cornerRadius(10.0) // Rounded corners for aesthetics
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(
                                    focusedField == .password ? Color("InfaqueColors") : Color.gray.opacity(0.5),
                                    lineWidth: 2
                                )
                        )
                        .padding(.horizontal, 20)
                        .focused($focusedField, equals: .password)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.bottom, 35)
                    
                    Toggle("Switch to Sign Up", isOn: $isSignUp)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.bottom, 25)
                    
                    
                    // Sign In Sign up Button
                    Button(action: {
                        
                        if isSignUp {
                            let userModel = LoginRequestModel(userId: "\(UUID())", email: email, password: password)
                            let (isLoginValid, errorMessage) = loginRequestModel.validate(requestModel: userModel)
                            if isLoginValid {
                                viewModel.signUp(email: email, password: password) { success in
                                    showError = !success
                                    if success {
                                        navigateToHomeTabBarView = true
                                    }
                                }
                            }
                            else {
                                statusMessage = errorMessage ?? ""
                            }
                        } else {
                            let userModel = LoginRequestModel(userId: "\(UUID())", email: email, password: password)
                            let (isLoginValidated, errorMessage) = loginRequestModel.validate(requestModel: userModel)
                            if isLoginValidated {
                                Task {
                                    let isSuccess = await viewModel.signIn(email: email, password: password)
                                    showError = !isSuccess
                                    print(viewModel.user?.email ?? "")
                                    if isSuccess {
                                        navigateToHomeTabBarView = true
                                    }
                                }
                            }
                            else {
                                statusMessage = errorMessage ?? ""
                            }

                            
                        }
                    }) {
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("InfaqueColors"))
                            .cornerRadius(10.0)
                            .padding(.horizontal, 20)
                    }
                    
                    
                    // Status Message
                    if !statusMessage.isEmpty {
                        Text(statusMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    if showError, let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Login")
                .navigationBarTitleDisplayMode(.inline)
                // Navigation destination tied to the state
                
                
                .navigationDestination(isPresented: $navigateToHomeTabBarView) {
                    HomeTabBarUIView()
                    
                }
            }
        }
        .onAppear {
        }
    }
    
    func login() {
        navigateToHomeTabBarView = true
    }
    
    
    
    
    
    //    func getCurrentUserEmail() -> String {
    //        if let user = Auth.auth().currentUser {
    //            return user.email ?? ""
    //        }
    //        return ""
    //    }
}

#Preview {
    LoginWithEmailUIView()
}
