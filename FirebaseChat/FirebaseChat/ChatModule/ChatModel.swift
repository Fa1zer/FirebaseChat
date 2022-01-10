//
//  ChatModel.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import Foundation
import FirebaseAuth

final class ChatModel {
    
    func singOut(didComplete: @escaping () -> Void, didNotComplite: @escaping () -> Void) {
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            didComplete()
        } catch {
            didNotComplite()
            
            print(error.localizedDescription)
        }
        
    }
    
}
