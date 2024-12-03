//
//  LoginWithEmailLinkUIView.swift
//  infaquePos
//
//  Created by Ankit Khanna on 29/11/24.
//

import SwiftUI
import FirebaseAuth

struct LoginWithEmailLinkUIView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    
    @State private var showError = false
    
    @State private var statusMessage: String = ""
    @State private var isLoggedIn: Bool = false
    //    @State private var currentUser: User?
    @FocusState private var focusedField: Field?
    @State private var navigateToHomeTabBarView = false
    
    @State private var isEmailSent: Bool = false
    @State private var message: String? = nil
    
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
                    
                    Text("Sign In using Email Link")
                    
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
                    
                    if isEmailSent {
                        Text("Email link sent! Check your inbox.")
                            .foregroundColor(.green)
                    } else if let message = message {
                        Text(message)
                            .foregroundColor(.red)
                    }
                    
//                    Toggle("Switch to Sign Up", isOn: $isSignUp)
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .padding(.bottom, 25)
                    
                    
                    // Sign In Sign up Button
                    Button(action: {
                        sendSignInLink()
                    
                    }) {
                        Text("Send Sign-In Link")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("InfaqueColors"))
                            .cornerRadius(10.0)
                            .padding(.horizontal, 20)
                    }.disabled(email.isEmpty)
                    
                    
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
        .navigationTitle("Sign In with Email Link")
        .onAppear {
        }
    }
    
    func login() {
        navigateToHomeTabBarView = true
    }
    
    func sendSignInLink() {
           let actionCodeSettings = ActionCodeSettings()
           actionCodeSettings.url = URL(string: "https://infaqueios.page.link/email-link-login")
           actionCodeSettings.handleCodeInApp = true
           actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)

           Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
               if let error = error {
                   message = "Error: \(error.localizedDescription)"
                   isEmailSent = false
                   return
               }

               UserDefaults.standard.set(self.email, forKey: "Email")
               isEmailSent = true
               message = nil
           }
       }
    
    

}


struct VerifyEmailView: View {
    @State private var message: String? = nil
    @StateObject private var viewModel = AuthViewModel()
    var body: some View {
        VStack {
            if let message = message {
                Text(message)
                    .foregroundColor(.red)
            }

            Button(action: verifySignInLink) {
                Text("Verify Email Link")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .onAppear(perform: verifySignInLink)
    }

    func verifySignInLink() {
        if let emailLink = UserDefaults.standard.string(forKey: "EmailLink"),
        
            Auth.auth().isSignIn(withEmailLink: emailLink),
           let email = UserDefaults.standard.string(forKey: "Email") {

            Auth.auth().signIn(withEmail: email, link: emailLink) { authResult, error in
                if let error = error {
                    message = "Error: \(error.localizedDescription)"
                    return
                }

                message = "Successfully signed in!"
            }
        } else {
            message = "Invalid or missing email link."
        }
    }
}

#Preview {
    LoginWithEmailLinkUIView()
}
