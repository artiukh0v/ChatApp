//
//  AlertManager.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 17.02.2023.
//

import UIKit
class AlertManager {
    // Accept UIViewController on wich we want to present alert and text and presenting UIAlertController
    static func showAlert(on vc: UIViewController,title: String,text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
