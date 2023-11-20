//
//  AppDelegate.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 12.02.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        isLogIn()
        return true
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }
    // func that checking is user loged or not
    func isLogIn() {
        if CurrentUserInfoUserDefaults.isLogin == true {
            mainVc()
        } else {
            logInVc()
        }
    }
    // func that set AuthorizationViewControler initial
    private func logInVc() {
        
        let navigationController = UINavigationController(rootViewController: AuthorizationViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    // func that set ProfileViewController initial
    private func mainVc() {
        let navigationController = UINavigationController(rootViewController: UsersViewController())
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
    }
}
    // MARK: UISceneSession Lifecycle

   

