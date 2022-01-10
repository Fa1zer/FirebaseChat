//
//  ChatViewController.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import UIKit
import SnapKit

final class ChatViewController: UIViewController, Coordinatable {
    
    init(chatModel: ChatModel) {
        
        self.chatModel = chatModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var navigationControllerDelegate: NavigationController?
    
    private let chatModel: ChatModel
    
    private let cellId = "message"
        
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let containerView: UIView = {
        let stackView = UIView()
        
        stackView.backgroundColor = .systemBlue
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let textField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .white
        view.textColor = .black
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.placeholder = "Message"
        view.tintColor = #colorLiteral(red: 0.3675304651, green: 0.5806378722, blue: 0.7843242884, alpha: 1)
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .clear
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.title = "Chat"
        self.navigationItem.title = "Chat"
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOutButton)
        )
        
        navigationControllerDelegate?.navigationBar.backgroundColor = .white

//        tableView.separatorColor = .clear
        
        self.view.addSubview(tableView)
        self.view.addSubview(containerView)
        self.view.addSubview(textField)
        self.view.addSubview(sendButton)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(textField.snp.top).inset(-16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(textField)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(50)
        }
        
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).inset(32)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(sendButton.snp.leading).inset(-16)
            make.height.equalTo(50)
        }
    }
    
    private func didCompliteSignOut() {
        self.navigationControllerDelegate?.popViewController(animated: true)
    }
    
    private func didNotCompliteSignOut() {
        self.presentAlert(title: "Произошла ошибка", text: nil)
    }
    
    @objc private func didTapSignOutButton() {
        chatModel.singOut(didComplete: didCompliteSignOut, didNotComplite: didNotCompliteSignOut)
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
}
