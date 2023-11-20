//
//  ForgotPasswordViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 18.02.2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    let emailView = UIView()
    let emailTextField = UITextField()

    // MARK: - Dependeces
    var authService: forgotPasswordProtocol!
    var validator: validatorForForgotPasswordProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInterface()
    // Initializing Dependeces
        authService = AuthService()
        validator = Validator()
        // Do any additional setup after loading the view.
    }
    private func createInterface() {
        let wallpaper = UIImageView()
        wallpaper.image = UIImage(named: "wallpaper")
        self.view.addSubview(wallpaper)
        
        wallpaper.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        let welcomeLabel = UILabel()
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 40)
        welcomeLabel.numberOfLines = 0
        welcomeLabel.text = "Restore password"
        welcomeLabel.textColor = .black
        self.view.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(180)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-101)
            make.height.equalTo(129)
        }
        
        emailView.backgroundColor = .white
        emailView.layer.cornerRadius = 30
        emailView.layer.borderWidth = 3
        emailView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(emailView)
        
        emailView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        
        emailTextField.placeholder = "Email"
        emailView.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 10))
        }
        
        let restoreButton = UIButton()
        restoreButton.setTitle("Restore", for: .normal)
        restoreButton.backgroundColor = UIColor(red: 0.124, green: 0.124, blue: 0.124, alpha: 0.5)
        restoreButton.layer.cornerRadius = 30
        restoreButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        restoreButton.layer.borderWidth = 3
        restoreButton.addTarget(self, action: #selector(restoreAction), for: .touchUpInside)
        self.view.addSubview(restoreButton)
        
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(48)
            make.left.equalToSuperview().offset(62)
            make.right.equalToSuperview().offset(-62)
            make.height.equalTo(63)
        }
    }
    
    @objc func restoreAction() {
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
