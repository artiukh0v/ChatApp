//
//  FireBaseRequests.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 22.02.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol UsersFBRequestsProtocol {
    func getAllUsers(completion: @escaping ([User]) -> Void)
    func getCurrentUserInfo(complition:@escaping (Error?, User?) -> Void)
}
class UsersFBRequests: UsersFBRequestsProtocol {
    // func that return all users without current user
    public func getAllUsers(completion: @escaping ([User]) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        Firestore.firestore().collection("users").whereField("email", isNotEqualTo: email)
            .getDocuments { snap, error in
                    
        guard let snap = snap else { return }
        let documents = snap.documents
        var usersResult = [User]()
            for document in documents {
                // id of user String type
                let userId = document.documentID
                // all user info
                let data = document.data()
                // username
                let username = data["username"] as! String
                // url string of user avatar image
                let avatarUrl = data["avatarURL"] as! String
                
                let user = User(userAvatarUrl: avatarUrl, userName: username, userId: userId)
                usersResult.append(user)
            }
            completion(usersResult)
        }
    }
    //MARK: getCurrentUserInfo
    // get current user information(url string of avatar image, username and Id)
    // set thet valus in UserDafaults CurrentUser property
    //                                                  imageURL userName Error
    public func getCurrentUserInfo(complition:@escaping (Error?, User?) -> Void ) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userUID).getDocument { snap, error in
            if let error = error {
                complition(error, nil)
            }
            guard let data = snap?.data() else { return }
            let avatarURL = data["avatarURL"] as! String
            let username = data["username"] as! String
            let user = User(userAvatarUrl: avatarURL, userName: username, userId: userUID)
            CurrentUserInfoUserDefaults.currentUser = user
            print(user.userId)
            DispatchQueue.main.async {
                print(CurrentUserInfoUserDefaults.currentUser?.userAvatarUrl as Any)
            }
            complition(nil, user)
        }
    }
}
