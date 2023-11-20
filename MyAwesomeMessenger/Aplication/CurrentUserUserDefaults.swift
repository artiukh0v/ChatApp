//
//  LogInUserDefaults.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 15.03.2023.
//
import Foundation

final class CurrentUserInfoUserDefaults {
    // Property that indicates whether the user is logged in or not
    static var isLogin: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
        set {
            let defaults = UserDefaults.standard
            if let newValue = newValue {
                defaults.set(newValue, forKey: "isLogin")
            } else {
                defaults.removeObject(forKey: "isLogin")
            }
        }
    }

    // Property that includes info of the current user
    static var currentUser: User? {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: "currentUser") as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? User else { return nil }
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = "currentUser"
            if let currentUser = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: currentUser, requiringSecureCoding: false) {
                    defaults.set(savedData, forKey: key)
                }
            }
        }
    }
}
