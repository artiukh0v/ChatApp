//
//  Validator.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 16.02.2023.
//

import Foundation
// protocol with functions that needs in RegisterPasswordViewController
protocol validatorForRegisterProtocol {
    func isValidEmail(email:String) -> Bool
    func isValidUsername(username: String) -> Bool
    func isValidPassword(password:String) -> Bool
}
// protocol with functions that needs in AuthorizationViewController
protocol validatorForAuthorizationProtocol {
    func isValidEmail(email:String) -> Bool
    func isValidPassword(password:String) -> Bool
}
// protocol with functions that needs in ForgotPasswordViewController
protocol validatorForForgotPasswordProtocol {
    func isValidEmail(email:String) -> Bool
}

class Validator: validatorForRegisterProtocol, validatorForAuthorizationProtocol, validatorForForgotPasswordProtocol {
    // func that accept email and if it valid
    // returning true if email is valid and false is invalid
    public func isValidEmail(email:String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRexEx = "[0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRexEx)
        return emailPred.evaluate(with: email)
    }
    // func that accept username and if it valid
    // returning true if username is valid and false is invalid
    public func isValidUsername(username: String) -> Bool {
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameRexEx = "\\w{4,24}"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRexEx)
        return usernamePred.evaluate(with: username)
    }
    // func that accept password and if it valid
    // returning true if password is valid and false is invalid
    public func isValidPassword(password:String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRexEx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRexEx)
        return passwordPred.evaluate(with: password)
    }
}
