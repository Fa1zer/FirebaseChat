//
//  Message.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 16.01.2022.
//

import UIKit
import MessageKit

struct Message: MessageType {
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}
