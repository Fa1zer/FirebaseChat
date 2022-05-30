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
import UIKit

final class ChatModel {
    
    init() {
        
        database.child("messages").observe(.value) { [ weak self ] snapshot in
            
            guard let value = snapshot.value as? [[String : String]] else { return }
            
            self?.dataMessages = value
            
        }
    }
    
    var callBack: (() -> Void)?
    
    var email: String? {
        
        DispatchQueue.main.async { [ weak self ] in
            self?.callBack?()
        }
        
        return Auth.auth().currentUser?.email
        
    }
        
    var messages = [Message]() {
        didSet {
            print(messages.count)
            
            callBack?()
        }
    }
    
    private var dataMessages = [[String : String]]() {
        didSet {
            
            messages = []
            
            dataMessages.forEach { value in
                
                messages.append(Message(sender: Sender(
                    senderId: "\(value["email"] ?? "none")", displayName: value["email"] ?? "none"),
                    messageId: "\(Int.random(in: 0...99999999))", sentDate: Date(),
                    kind: .text(value["text"] ?? "Не удалось загрузить сообщение.")))
            }
        }
    }
    
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
                
        guard let email = Auth.auth().currentUser?.email else { return }
        
        var value = dataMessages as [[String : NSObject]]
        
        let message = [
            "email" : email as NSObject,
            "text" : text as NSObject
        ]
        
        value.append(message)
        
        database.child("messages").setValue(value)
    }
    
}
