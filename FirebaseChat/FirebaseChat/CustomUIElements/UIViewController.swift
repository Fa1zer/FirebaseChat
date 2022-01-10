//
//  UIViewController.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true)
    }
    
    func presentAlertWithAction(title: String, text: String?, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let firstAlertAction = UIAlertAction(title: "Да", style: .default) { _ in action() }
        let secondAlertAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(firstAlertAction)
        alert.addAction(secondAlertAction)
        
        self.present(alert, animated: true)
    }
    
}
