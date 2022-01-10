//
//  NavigationController.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import UIKit

final class NavigationController: UINavigationController {
    
    private let logInViewController = LogInViewController(logInModel: LogInModel())
    private let chatViewController = ChatViewController(chatModel: ChatModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat"
        self.viewControllers = [logInViewController]
        
        configureViewControllers()
    }
    
    private func configureViewControllers() {
        logInViewController.navigationControllerDelegate = self
        chatViewController.navigationControllerDelegate = self
    }
    
    func pushLogInViewController() {
        self.pushViewController(logInViewController, animated: true)
    }
    
    func pushChatViewController() {
        self.pushViewController(chatViewController, animated: true)
    }
    
}
