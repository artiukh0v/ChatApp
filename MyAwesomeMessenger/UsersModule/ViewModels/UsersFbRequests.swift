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
}
