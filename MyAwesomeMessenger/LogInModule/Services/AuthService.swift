//
//  AuthService.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 16.02.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol methodsForRegisterProtcol {
    func registerUser(with userInfo: RegisterUserInfo, complition: @escaping (Error?) -> Void)
}

protocol methodsForAuthorizationProtcol {
    func logIn(with userInfo: LogInUserInfo,copmplition: @escaping (Error?)->Void)
}

protocol forgotPasswordProtocol {
    func forgotPassword(with email: String, complition: @escaping(Error?) -> Void)
}


class AuthService: methodsForRegisterProtcol, methodsForAuthorizationProtcol, forgotPasswordProtocol {
    // MARK: - Register
public func registerUser(with userInfo: RegisterUserInfo, complition: @escaping (Error?) -> Void) {
    let email = userInfo.email
    let password = userInfo.password
    let username = userInfo.name
        
    // creating new user in firestore
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error { complition(error); return }
            guard let userResult = result?.user else { return }
             let db = Firestore.firestore()
                    db.collection("users")
                        .document(userResult.uid)
                            .setData(["username": username,
                                      "email": email,
                                      "password": password,
                                      "avatarURL": "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/4X/6/c/0/6c046c5dea4420b7fddec1b6076c7be94958a528.png"]) { error in
                                if let error = error {
                                    complition(error)
                                    return }
                    }
             }
        }
   
        // MARK: - LogIn
        public func logIn(with userInfo: LogInUserInfo,copmplition: @escaping (Error?)->Void) {
            Auth.auth().signIn(withEmail: userInfo.email, password: userInfo.password) { result, error in
                if let error = error {
                    copmplition(error)
                    return
                } else {
                    copmplition(nil)
                    // set CurrentUserInfoUserDefaults isLogin property value true
                    CurrentUserInfoUserDefaults.isLogin = true
                }
                
            }
        }
    //MARK: - Forgot Password
        public func forgotPassword(with email: String, complition: @escaping(Error?) -> Void) {
            // sending new password on user email
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    complition(error)
                }
            }
        }
    }

