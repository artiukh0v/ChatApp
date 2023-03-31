//
//  RegisterViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 13.02.2023.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
  //MARK: Outlets 
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    
    // MARK: - Dependeces
    var authService: methodsForRegisterProtcol!
    var validator: validatorForRegisterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Initializing Dependeces
        authService = AuthService()
        validator = Validator()
        
       gestureRecognizer()
    }
    // MARK: - GestereRecognizer for hide keyboard
    private func gestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endAdditing))
        self.view.addGestureRecognizer(gesture)
    }
    @objc func endAdditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func showPassword(_ sender: Any) {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    
    
    
    
    //MARK: - haveAccountButton
    @IBAction func haveAccountButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - registerButton
    @IBAction func registerButton(_ sender: Any) {
        let userInfo = RegisterUserInfo(name: self.usernameTextField.text ?? "",
                                        email: self.emailTextField.text ?? "",
                                        password: self.passwordTextField.text ?? "")
        // checking is email valid
        if !validator.isValidEmail(email: userInfo.email) {
            AlertManager.showAlert(on: self, title: "Error", text: "Invalid Email")
            return
        }
        // checking is password valid
        if !validator.isValidPassword(password: userInfo.password) {
            AlertManager.showAlert(on: self, title: "Error", text: "Invalid Password")
            return
        }
        // cheacking is username valid
        if !validator.isValidUsername(username: userInfo.name) {
            AlertManager.showAlert(on: self, title: "Error", text: "Invalid Username")
            return
        }
        authService.registerUser(with: userInfo) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showAlert(on: self, title: "Error", text: error.localizedDescription)
                return
            }
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthorizationViewController") as! AuthorizationViewController
        self.navigationController?.pushViewController(vc, animated: true)
            
    }
}

