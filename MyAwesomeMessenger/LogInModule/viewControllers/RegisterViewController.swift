//
//  RegisterViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 13.02.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    let usernameView = UIView()
    let usernameTextField = UITextField()
    let emailView = UIView()
    let emailTextField = UITextField()
    let passwordView = UIView()
    let passwordTextField = UITextField()
    
    // MARK: - Dependeces
    var authService: methodsForRegisterProtcol!
    var validator: validatorForRegisterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createInterface()
        gestureRecognizer()
        
        // Initializing Dependeces
        authService = AuthService()
        validator = Validator()
    }
    
    //MARK: Interface
    private func createInterface() {
        //MARK: - Wallpaper
        let wallpaper = UIImageView()
        wallpaper.image = UIImage(named: "wallpaper")
        self.view.addSubview(wallpaper)
        // Constrains
        wallpaper.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        //MARK: Welcome Label
        // "Create Your Acccount" Label
        let welcomeLabel = UILabel()
        welcomeLabel.numberOfLines = 0
        welcomeLabel.text = "Create Your Acccount"
        welcomeLabel.textColor = .black
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.view.addSubview(welcomeLabel)
        // Constrains
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(93)
            make.left.equalToSuperview().offset(33)
            make.right.equalToSuperview().offset(-84)
            make.height.equalTo(80)
        }
        //MARK: - Username TextField
        usernameView.layer.cornerRadius = 30
        usernameView.layer.borderWidth = 3
        usernameView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        usernameView.backgroundColor = .white
        self.view.addSubview(usernameView)
        // Constrains
        usernameView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(43)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        
        usernameTextField.placeholder = "username"
        usernameView.addSubview(usernameTextField)
        // Constrains
        usernameTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 10))
        }
        //MARK: Email TextField
        emailView.layer.cornerRadius = 30
        emailView.layer.borderWidth = 3
        emailView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.backgroundColor = .white
        self.view.addSubview(emailView)
        // Constrains
        emailView.snp.makeConstraints { make in
            make.top.equalTo(usernameView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        emailTextField.placeholder = "email"
        emailView.addSubview(emailTextField)
        // Constrains
        emailTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 10))
        }
        //MARK: Password TextField
        passwordView.layer.cornerRadius = 30
        passwordView.layer.borderWidth = 3
        passwordView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.backgroundColor = .white
        self.view.addSubview(passwordView)
        // Constrains
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        passwordTextField.placeholder = "password"
        passwordView.addSubview(passwordTextField)
        // Constrains
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 10))
        }
        //MARK: - Show Password Button
        let eyeButton = UIButton()
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        passwordView.addSubview(eyeButton)
        // Constrains
        eyeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 276, bottom: 5, right: 15))
        }
        //MARK: - Sing In Button
        let singInButton = UIButton()
        singInButton.layer.cornerRadius = 30
        singInButton.layer.borderWidth = 3
        singInButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        singInButton.backgroundColor = UIColor(red: 0.124, green: 0.124, blue: 0.124, alpha: 0.5)
        singInButton.setTitle("Sing In", for: .normal)
        singInButton.addTarget(self, action: #selector(singInAction), for: .touchUpInside)
        self.view.addSubview(singInButton)
        // Constrains
        singInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(62)
            make.right.equalToSuperview().offset(-62)
            make.height.equalTo(63)
        }
    }
    
    //MARK: - registerButton
    @objc func singInAction() {
        let userInfo = RegisterUserInfo(name: self.usernameTextField.text ?? "",
                                        email: self.emailTextField.text ?? "",
                                        password: self.passwordTextField.text ?? "")
        // checking is email valid
        if !validator.isValidEmail(email: userInfo.email) {
            emailView.layer.borderColor = CGColor(red: 0.962, green: 0.044, blue: 0.044, alpha: 1)
            emailTextField.text = nil
            return
        }
        // checking is password valid
        if !validator.isValidPassword(password: userInfo.password) {
            passwordView.layer.borderColor = CGColor(red: 0.962, green: 0.044, blue: 0.044, alpha: 1)
            passwordTextField.text = nil
            return
        }
        // cheacking is username valid
        if !validator.isValidUsername(username: userInfo.name) {
            usernameView.layer.borderColor = CGColor(red: 0.962, green: 0.044, blue: 0.044, alpha: 1)
            usernameTextField.text = nil
            return
        }
        authService.registerUser(with: userInfo) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showAlert(on: self, title: "Error", text: error.localizedDescription)
                return
            }
        }
        let vc = AuthorizationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Show Password Action
    @objc func showPassword() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    
    // MARK: - GestereRecognizer for hide keyboard
    private func gestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endAdditing))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func endAdditing() {
        self.view.endEditing(true)
    }
}
