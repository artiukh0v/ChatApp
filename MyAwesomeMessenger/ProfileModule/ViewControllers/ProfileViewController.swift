//
//  ProfileViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 20.02.2023.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - Dependeces
    private var profileViewModel: methodsForProfileProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewModel = ProfileViewModel()
        settingUserImage()
        setUserData()
    }
    // MARK: setUserData
    private func setUserData() {
        profileViewModel.getCurrentUserInfo { [weak self] userInfo, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let userInfo = userInfo,
                  let url = URL(string: userInfo.userAvatarUrl)
            else { return }
            // set username in usernameLabel.text
            self?.usernameLabel.text = userInfo.userName
            // set user avatar in userImageView.image 
            self?.userImageView.sd_setImage(with: url)
        }
    }
    // MARK: LogOutButton
    @IBAction func LogOutButton(_ sender: Any) {
        // Log Out from account
        profileViewModel.logOut { error in
            if let error = error {
                AlertManager.showAlert(on: self, title: "Error", text: error.localizedDescription)
                return
            }
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isLogIn()
        
    }
    // MARK: - UserImageView Settings
    private func settingUserImage() {
        
        userImageView.tintColor = .gray
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderWidth = 2
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
   
    
    @IBAction func addPhotoButton(_ sender: Any) {
        presentLibrary()
    }
    
}
// MARK: UIImagePickerController
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        self.present(vc, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.userImageView.image = selectedImage
        profileViewModel.uploadImage(image: selectedImage) {[weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showAlert(on: self, title: "Error", text: error.localizedDescription)
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
