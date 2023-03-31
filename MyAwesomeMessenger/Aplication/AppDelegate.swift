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
    // func that set WelcomeViewControler initial
    private func logInVc() {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        let vc = UINavigationController(rootViewController: VC)
        vc.isNavigationBarHidden = true
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    // func that set ProfileViewController initial
    private func mainVc() {
        let tabBar = UITabBarController()
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        let usersVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
        let usersNavController = UINavigationController(rootViewController: usersVC)
        usersNavController.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "message"), selectedImage:  UIImage(systemName: "message.fill"))
        
        let controllers = [profileVC, usersNavController]
        tabBar.setViewControllers(controllers, animated: true)
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        
    }
}
    // MARK: UISceneSession Lifecycle

   

