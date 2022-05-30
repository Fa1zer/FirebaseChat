//
//  ChatViewController.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import UIKit
import SnapKit
import MessageKit
import InputBarAccessoryView

final class ChatViewController: MessagesViewController, Coordinatable {
    
    init(chatModel: ChatModel) {
        
        self.chatModel = chatModel
                
        super.init(nibName: nil, bundle: nil)
        
        chatModel.callBack = { [ weak self ] in self?.messagesCollectionView.reloadData() }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var navigationControllerDelegate: NavigationController?
    
    private let chatModel: ChatModel
    
    private let whiteView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.navigationControllerDelegate?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "Chat"
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapSignOutButton))
        
        self.view.addSubview(whiteView)        
        
        whiteView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        let frame = navigationControllerDelegate?.navigationBar.frame ?? .zero
        
        navigationControllerDelegate?.navigationBar.frame = CGRect(
            origin: frame.origin,
            size: CGSize(width: frame.width, height: frame.height + 50)
        )
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        messagesCollectionView.scrollToBottom(animated: false)
    }
    
    @objc private func didTapSignOutButton() {
        
        chatModel.singOut {
            self.navigationControllerDelegate?.popViewController(animated: true)
            
            self.viewDidDisappear(true)
            
        } didNotComplite: {
            
            self.presentAlert(title: "Произошла ошибка", text: nil)
            
        }

    }
    
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    func currentSender() -> SenderType {
        return Sender(senderId: "\(chatModel.email ?? "none")",
                      displayName: chatModel.curentUsserEmail())
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatModel.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatModel.messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        chatModel.newMessage(text: text)
        
        messagesCollectionView.scrollToBottom(animated: true)
        
        inputBar.inputTextView.text = ""
    }
    
}
