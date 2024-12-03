//
//  AppleSignInViewModel.swift
//  infaquePos
//
//  Created by Ankit Khanna on 30/11/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import SwiftUI

struct UserModel: Codable {
    var userId: String?
    var email: String?
    var fullName: String?
}

struct AppleSignInViewModel {
    
    @State private var userId: String?
    @State private var isLoggedIn: Bool = false

    
    func handleAuthorizationRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAuthorizationResult(result: Result<ASAuthorization, Error>, completion: @escaping (_ userModel: UserModel, _ result: Bool) -> Void) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Extract user information
                let userId = appleIDCredential.user
                self.userId = userId
                self.isLoggedIn = true
                // Save user ID securely (e.g., Keychain)
                print("User ID: \(userId)")
                var userModel: UserModel
                let email = appleIDCredential.email ?? ""
                print("Email: \(email)")
                let givenName = appleIDCredential.fullName?.givenName ?? ""
                let familyName = appleIDCredential.fullName?.familyName ?? ""
                    print("Full Name: \(givenName) \(familyName)")
                if userId != "" {
                    userModel = UserModel(userId: userId, email: email, fullName:  "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")")
                    completion(userModel, true)
                }
            }
        case .failure(let error):
            print("Sign in with Apple failed: \(error.localizedDescription)")
        }
    }
    
}
