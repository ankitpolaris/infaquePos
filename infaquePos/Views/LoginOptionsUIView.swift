//
//  LoginScreenView.swift
//  infaquePos
//
//  Created by Ankit Khanna on 27/11/24.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift

struct LoginOptionsUIView: View {
    
    @State private var user: GIDGoogleUser?
    @State private var errorMessage: String?
    @State private var statusMessage: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var userId: String?
    private var appleSignInViewModel = AppleSignInViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Image("brandLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: UIScreen.main.bounds.height / 4)
                        .padding(.bottom, 20)
                    
                    // Sign In Button
                    NavigationLink(destination: LoginWithEmailUIView(), label: {
                        Text("Sign In with Email")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(7.0)
                            .padding(.horizontal, 20)
                    })
                    
                    
                    // Sign In With Email Link Button
                    NavigationLink(destination: LoginWithEmailLinkUIView(), label: {
                        Text("Sign In with Email Link")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(7.0)
                            .padding(.horizontal, 20)
                    })
                    
                       Button(action: {
                           googleSignIn()
                       }) {
                        
                           Image("ios_neutral_sq_SU")
                               .resizable()
                               .frame(height: 52.0)
                               .padding(.leading, 2)
                               .padding(.trailing, 2)
                               .padding(.top, 20)
                               .background(Color.clear)
                               .foregroundColor(.black)
                               .cornerRadius(7.0)
                       }
                       .padding()
      
                    
                    SignInWithAppleButton(.signIn) { request in
                        appleSignInViewModel.handleAuthorizationRequest(request: request)
//                        handleAuthorizationRequest(request: request)
                    } onCompletion: { result in
                        appleSignInViewModel.handleAuthorizationResult(result: result) { userModel, result in
                            if result {
                                self.userId = userId
                                self.isLoggedIn = true
                            }
                        }
//                        handleAuthorizationResult(result: result)
                    }
                    .signInWithAppleButtonStyle(.white) // Options: black, white, whiteOutline
                    .frame(height: 50)
//                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .cornerRadius(7.0)
                    
                    // Status Message
                    if !statusMessage.isEmpty {
                        Text(statusMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Login")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $isLoggedIn) {
                    HomeTabBarUIView()

                }
            }
        }
        .onAppear {
//            restorePreviousSignIn()
            checkIfLoggedIn()
        }
    }
    
//    private func handleAuthorizationRequest(request: ASAuthorizationAppleIDRequest) {
//        request.requestedScopes = [.fullName, .email]
//    }
    
//    private func handleAuthorizationResult(result: Result<ASAuthorization, Error>) {
//        switch result {
//        case .success(let authorization):
//            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                // Extract user information
//                let userId = appleIDCredential.user
//                self.userId = userId
//                self.isLoggedIn = true
//                // Save user ID securely (e.g., Keychain)
//                print("User ID: \(userId)")
//                if let email = appleIDCredential.email {
//                    print("Email: \(email)")
//                }
//                if let fullName = appleIDCredential.fullName {
//                    print("Full Name: \(fullName)")
//                }
//            }
//        case .failure(let error):
//            print("Sign in with Apple failed: \(error.localizedDescription)")
//        }
//    }
    
    private func googleSignIn() {
    
        let clientId = "313548921680-qo0a24nnmu0qj8ucs15n076jkdkag2vl.apps.googleusercontent.com"
        
        
//        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else {
//            print("Client ID not found in GoogleService-Info.plist")
//            errorMessage = "Client ID not found. Check GoogleService-Info.plist."
//            return
//        }
        
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        let configuration = GIDConfiguration.init(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = configuration
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.user = result?.user
            errorMessage = nil
            
            if let idToken = result?.user.idToken?.tokenString {
                print("ID Token: \(idToken)")
            }
            if let userEmail = result?.user.profile?.email {
                print("Email: \(userEmail)")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.isLoggedIn = true
            }
            if let familyName = result?.user.profile?.familyName {
                print("familyName: \(familyName)")
            }
            
        }
        
    }
    
    private func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("Restore sign-in failed: \(error.localizedDescription)")
                // Handle gracefully: prompt user to sign in manually.
                return
            }

            if let user = user {
                print("Restore successful! User: \(user.profile?.name ?? "Unknown")")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                // Proceed with the restored user.
            } else {
                print("No previous sign-in exists.")
            }
            self.user = user
        }
    }
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        user = nil
        errorMessage = nil
    }
    
    private func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            fatalError("Unable to find root view controller.")
        }
        return rootViewController
    }
    
   
    
    private func checkIfLoggedIn() {
        //        if let user = Auth.auth().currentUser {
        //            currentUser = user
        //            isLoggedIn = true
        //        }
    }
    
    //    func getCurrentUserEmail() -> String {
    //        if let user = Auth.auth().currentUser {
    //            return user.email ?? ""
    //        }
    //        return ""
    //    }
}

#Preview {
    LoginOptionsUIView()
}
