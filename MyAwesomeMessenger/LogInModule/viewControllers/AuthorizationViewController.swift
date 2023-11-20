//
//  AuthorizationViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 13.02.2023.
//

import UIKit
import SnapKit

class AuthorizationViewController: UIViewController {
    
    
    let eyeButton = UIButton()
    let emailView = UIView()
    let emailTextField = UITextField()
    let passwordView = UIView()
    let passwordTextField = UITextField()
    
    
    // MARK: - Dependeces
    var authService: methodsForAuthorizationProtcol!
    var validator: validatorForAuthorizationProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing Dependeces
        authService = AuthService()
        validator = Validator()
        
        gestureRecognizer()
        createInterface()
    }
    // MARK: - GestereRecognizer keyboard
    private func gestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endAdditing))
        self.view.addGestureRecognizer(gesture)
    }
    @objc func endAdditing() {
        self.view.endEditing(true)
    }
    
    private func createInterface() {
        //MARK: - Wallpaper
        let wallpaperImageView = UIImageView()
        wallpaperImageView.image = UIImage(named: "wallpaper")
        wallpaperImageView.contentMode = .scaleAspectFill
        self.view.addSubview(wallpaperImageView)
        
        wallpaperImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //MARK: - AppLogo
        let appLogoImageView = UIImageView()
        appLogoImageView.layer.cornerRadius = 90
        appLogoImageView.backgroundColor = .white
        appLogoImageView.layer.borderWidth = 3
        appLogoImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        appLogoImageView.image = UIImage(named: "Icon")
        appLogoImageView.contentMode = .scaleAspectFill
        self.view.addSubview(appLogoImageView)
        
        appLogoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(180)
        }
        
        //MARK: - EmailTextField
        emailView.layer.cornerRadius = 33
        emailView.layer.borderWidth = 3
        emailView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.backgroundColor = .white
        self.view.addSubview(emailView)
        
        emailView.snp.makeConstraints { make in
            make.top.equalTo(appLogoImageView.snp.bottom).offset(34)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(70)
        }
       
        emailTextField.placeholder = "email"
        emailView.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 10))
        }
        
        //MARK: - PasswordTextField
        passwordView.layer.cornerRadius = 33
        passwordView.layer.borderWidth = 3
        passwordView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.backgroundColor = .white
        self.view.addSubview(passwordView)
        
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(29)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(70)
        }
       
        passwordTextField.placeholder = "password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .black
        passwordView.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 10))
        }
        //MARK: - Show Password Button
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        passwordView.addSubview(eyeButton)
        
        eyeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 276, bottom: 5, right: 15))
        }
        
        //MARK: - LogInButton
        let logInButton = UIButton()
        logInButton.backgroundColor = UIColor(red: 0.124, green: 0.124, blue: 0.124, alpha: 0.5)
        logInButton.layer.cornerRadius = 30
        logInButton.layer.borderWidth = 3
        logInButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
        self.view.addSubview(logInButton)
        
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(27)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(62)
        }
        //MARK: - Forgot Password Button
        let forgotPasswordButton = UIButton()
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.setTitleColor(.black, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(goRestorePassword), for: .touchUpInside)
        self.view.addSubview(forgotPasswordButton)
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(27)
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-100)
            make.height.equalTo(18)
        }
        //MARK: - go
        let singUpButton = UIButton()
        singUpButton.setTitle("Don't have account? Sing Up", for: .normal)
        singUpButton.setTitleColor(.black, for: .normal)
        singUpButton.addTarget(self, action: #selector(singUpAction), for: .touchUpInside)
        self.view.addSubview(singUpButton)
        
        singUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-63)
            make.left.equalToSuperview().offset(43)
            make.right.equalToSuperview().offset(-43)
            make.height.equalTo(24)
        }
        
        
    }
    
    //MARK: - LogIn Button Action
    @objc func logInAction() {
        let userInfo = LogInUserInfo(email: emailTextField.text ?? "",
                                     password: passwordTextField.text ?? "")
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
        authService.logIn(with: userInfo) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showAlert(on: self, title: "Error", text: error.localizedDescription)
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.emailView.layer.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
                self?.passwordView.layer.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.isLogIn()
            }
        }
    }
    //MARK: Sing Up Action
    @objc func singUpAction() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    //MARK: Show Password Action
    @objc func showPassword() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    //MARK: - Forgot Password Action
    @objc func goRestorePassword() {
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }

}

