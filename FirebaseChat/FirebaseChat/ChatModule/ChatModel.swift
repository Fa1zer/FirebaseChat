//
//  ChatModel.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import MessageKit

final class ChatModel {
    
    init() {
        database.observeSingleEvent(of: .value) { snapshot in
            
            guard let value = snapshot.value as? [[String : String]] else { return }
            
            value.forEach { [ weak self ] value in
                self?.messages.append(Message(sender: Sender(
                    senderId: "\(Int.random(in: 0...99999999))", displayName: value["email"] ?? "none"),
                    messageId: "\(Int.random(in: 0...99999999))", sentDate: Date(),
                    kind: .text(value["text"] ?? "Не удалось загрузить сообщение."))
                )
            }
        }
    }
    
    private(set) var messages = [Message]()
    
    private let database = Database.database().reference()
    
    func singOut(didComplete: @escaping () -> Void, didNotComplite: @escaping () -> Void) {
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            didComplete()
        } catch {
            didNotComplite()
            
            print(error.localizedDescription)
        }
        
    }
    
    func curentUsserEmail() -> String {
        
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return "" }
        
        return email
    }
    
    func newMessage(text: String) {
        
        database.getData { [ weak self ] error, snapshot in
            
            if let error = error {
                print(error)
                
                return
            }
            
            guard var value = snapshot.value as? [[String : String]] else { return }
            
            let message = ["email" : Auth.auth().currentUser?.email ?? "none",
                            "text" : text]
            
            value.append(message)
            
            self?.database.child("message").setValue(message)
        }
    }
    
}
