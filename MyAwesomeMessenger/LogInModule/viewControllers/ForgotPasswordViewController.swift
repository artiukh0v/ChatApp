//
//  ForgotPasswordViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 18.02.2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    // MARK: - Dependeces
    var authService: forgotPasswordProtocol!
    var validator: validatorForForgotPasswordProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
    // Initializing Dependeces
        authService = AuthService()
        validator = Validator()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resentPasswordButton(_ sender: Any) {
        let email = emailTextField.text ?? ""
        // cheack is email valid
        if !validator.isValidEmail(email: email) {
            AlertManager.showAlert(on: self, title: "Error", text: "Invalid Email")
            return 
        }
        // func that send reset password
        authService.forgotPassword(with: email) {[weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error)
                AlertManager.showAlert(on: self, title: "Error", text: error.localizedDescription)
                return
            }
        }
        AlertManager.showAlert(on: self, title: "Cheack your email", text: "We have send reset password email")
    }
    
   

}
