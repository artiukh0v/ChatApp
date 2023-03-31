//
//  UsersModel.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 22.02.2023.
//

import UIKit

class User: NSObject, NSCoding {
    let userAvatarUrl: String
    let userName: String
    let userId: String
    
    // default init
    init(userAvatarUrl: String, userName: String, userId: String) {
        self.userAvatarUrl = userAvatarUrl
        self.userName = userName
        self.userId = userId
    }
    // func that needs for UserDefaults
    func encode(with coder: NSCoder) {
        coder.encode(userAvatarUrl, forKey: "userAvatarUrl")
        coder.encode(userName, forKey: "userName")
        coder.encode(userId, forKey: "userId")
    }
    // init that needs for UserDefaults
    required init?(coder: NSCoder) {
        userAvatarUrl = coder.decodeObject(forKey: "userAvatarUrl") as? String ?? ""
        userName = coder.decodeObject(forKey: "userName") as? String ?? ""
        userId = coder.decodeObject(forKey: "userId") as? String ?? ""
    }
}
