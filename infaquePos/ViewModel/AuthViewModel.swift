//
//  AuthViewModel.swift
//  infaquePos
//
//  Created by Ankit Khanna on 28/11/24.
//

import Foundation
import FirebaseAuth



class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                self.user = result?.user
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                completion(true)
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                self.user = result?.user
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                completion(true)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No user is logged in."
            return
        }
        
        // Reauthenticate the user if necessary
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
        user.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                self.errorMessage = "Reauthentication failed: \(error.localizedDescription)"
                return
            }
            
            // Update the password
            
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    self.errorMessage = "Failed to update password: \(error.localizedDescription)"
                    completion(false)
                } else {
                    self.user = user
                    self.errorMessage = ""
                    completion(true)
                }
            }
        }
    }
          
    
}


