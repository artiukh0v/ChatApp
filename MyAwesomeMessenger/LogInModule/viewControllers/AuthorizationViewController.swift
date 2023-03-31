//
//  AuthorizationViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 13.02.2023.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    // MARK: - Dependeces
    var authService: methodsForAuthorizationProtcol!
    var validator: validatorForAuthorizationProtocol!
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
    
    
    @IBAction func showPassword(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true 
        }
    }
    
    
    // MARK: - registerButton
    @IBAction func registerButton(_ sender: Any) {
        // Go to WellcomeViewController
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - forgotPasswordButton
    @IBAction func forgotPasswordButton(_ sender: Any) {
        
    }
    //MARK: - logInButton
    @IBAction func logInButton(_ sender: Any) {
        let userInfo = LogInUserInfo(email: emailTextField.text ?? "",
                                     password: passwordTextField.text ?? "")
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
        authService.logIn(with: userInfo) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showAlert(on: self, title: "Error", text: error.localizedDescription)
                return 
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.isLogIn()
            }
        }
    }
}

