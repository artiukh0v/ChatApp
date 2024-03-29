//
//  FirebaseRequests.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 20.02.2023.
//
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


protocol methodsForProfileProtocol {
    func logOut(complition: @escaping (Error?)->Void)
    func uploadImage(image: UIImage, complition: @escaping(Error?)->Void)
}

class ProfileViewModel: methodsForProfileProtocol {
    //MARK: - Log Out
    public func logOut(complition: @escaping (Error?)->Void) {
        do {
            // log out current user
            try Auth.auth().signOut()
            // set UserDefault property isLogin value false
            CurrentUserInfoUserDefaults.isLogin = false 
            complition(nil)
        } catch let error {
            complition(error)
        }
    }
    //MARK: uploadImage
    // upload image in Storage and set the url string of this image in user firestore
    public func uploadImage(image: UIImage, complition: @escaping(Error?)->Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let referens = Storage.storage().reference().child("Avatars").child(userUID)
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        referens.putData(imageData,metadata: metaData)
        referens.downloadURL { url, error in
            guard let url = url else {
                return
            }
            let db = Firestore.firestore()
            db.collection("users")
                .document(userUID)
                .setData(["avatarURL": url.absoluteString], merge: true) { error  in
                    
                }
        }
    }
   
}
