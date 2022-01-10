//
//  LogInModel.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import Foundation
import FirebaseAuth

final class LogInModel {
    func signIn(email: String, password: String,
                didComplete: @escaping () -> Void,
                didNotComplete: @escaping () -> Void) {
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { _, error in
            
            if let error = error {
                
                didNotComplete()
                
                print(error.localizedDescription)
                
            } else {
                didComplete()
            }
            
        }
    }
    
    func logIn(email: String, password: String,
                didComplete: @escaping () -> Void,
                didNotComplete: @escaping () -> Void) {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { _, error in
            
            if let error = error {
                
                didNotComplete()
                
                print(error.localizedDescription)
                
            } else {
                didComplete()
            }
            
        }
    }
    
}
