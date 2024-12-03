//
//  Untitled.swift
//  infaquePos
//
//  Created by Ankit Khanna on 02/12/24.
//


struct LoginValidationViewModel {
    
    func validate(requestModel: LoginRequestModel) -> (isValid: Bool, errorMessage: String?) {
        guard let email = requestModel.email, !email.isEmpty else {
            return (false, "Email is required.")
        }
        guard email.count >= 6 else {
            return (false, "Email must be at least 6 characters long.")
        }
        guard email.contains("@") else {
            return (false, "Email must contain '@'.")
        }
        guard let password = requestModel.password, !password.isEmpty else {
            return (false, "Password is required.")
        }
        guard password.count >= 6 else {
            return (false, "Password must be at least 6 characters long.")
        }
        return (true, nil)
    }
}
