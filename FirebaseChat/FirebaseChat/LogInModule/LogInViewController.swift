//
//  LogInViewController.swift
//  FirebaseChat
//
//  Created by Artemiy Zuzin on 08.01.2022.
//

import UIKit
import SnapKit
import KeychainAccess

final class LogInViewController: UIViewController, Coordinatable {
    
    init(logInModel: LogInModel) {
        self.logInModel = logInModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let logInModel: LogInModel
    
    var navigationControllerDelegate: NavigationController?
    
    private let keychain = Keychain(service: "bdfg.FirebaseChat")
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let registrationLabel: UILabel = {
        let label = UILabel()
        
        label.text = "REGISTRATION"
        label.backgroundColor = .white
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 30)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let emailTextField: UITextField = {
       let emailOrPhone = UITextField()
        
        emailOrPhone.tintColor = #colorLiteral(red: 0.3675304651, green: 0.5806378722, blue: 0.7843242884, alpha: 1)
        emailOrPhone.textColor = .black
        emailOrPhone.font = UIFont.systemFont(ofSize: 16)
        emailOrPhone.autocapitalizationType = .none
        emailOrPhone.backgroundColor = .systemGray6
        emailOrPhone.placeholder = "Email or phone"
        emailOrPhone.layer.cornerRadius = 10
        emailOrPhone.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        emailOrPhone.layer.borderColor = UIColor.lightGray.cgColor
        emailOrPhone.layer.borderWidth = 0.5
        emailOrPhone.translatesAutoresizingMaskIntoConstraints = false
        emailOrPhone.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        emailOrPhone.leftViewMode = .always
        emailOrPhone.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        emailOrPhone.rightViewMode = .always
        
        return emailOrPhone
    }()
    
    private let passwordTextField: UITextField = {
       let password = UITextField()
        
        password.tintColor = #colorLiteral(red: 0.3675304651, green: 0.5806378722, blue: 0.7843242884, alpha: 1)
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.backgroundColor = .systemGray6
        password.isSecureTextEntry = true
        password.placeholder = "Password"
        password.layer.cornerRadius = 10
        password.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.5
        password.translatesAutoresizingMaskIntoConstraints = false
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        password.leftViewMode = .always
        password.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        password.rightViewMode = .always
        
        return password
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if let email = keychain["email"], let password = keychain["password"] {
            
            self.presentAlertWithAction(title: "Использовать созраненный email и пароль?",
                                        text: nil) { [ weak self ] in
                
                self?.useKeychain(email: email, password: password)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboadWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addSubview(registrationLabel)
        stackView.addSubview(emailTextField)
        stackView.addSubview(passwordTextField)
        stackView.addSubview(signInButton)
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(scrollView)
            make.width.equalTo(self.view)
        }
        
        registrationLabel.snp.makeConstraints { make in
            make.centerX.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().inset(120)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalTo(registrationLabel.snp.bottom).inset(-120)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.trailing.leading.height.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(100)
        }
        
    }
    
    private func useKeychain(email: String, password: String) {
        
        DispatchQueue.main.async { [ weak self ] in
            
            self?.emailTextField.text = email
            self?.passwordTextField.text = password
        }
    }
    
    private func didCompleteSignIn() {
        navigationControllerDelegate?.pushChatViewController()
        
        keychain["email"] = emailTextField.text!
        keychain["password"] = passwordTextField.text!
        
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    private func didNotCompleteSignIn() {
        self.presentAlertWithAction(title: "Пользователь не зарегестрирован",
                                    text: "Зарегестрировать пользователя?") { [ weak self ] in
            
            self?.logInModel.logIn(email: (self?.emailTextField.text)!,
                                   password: (self?.passwordTextField.text)!,
                                   didComplete: (self?.didCompleteLogIn)!,
                                   didNotComplete: (self?.didNotCompleteLogIn)!)
        }
    }
    
    private func didCompleteLogIn() {
        self.presentAlert(title: "Пользователь зарегестрирован", text: nil)
    }
    
    private func didNotCompleteLogIn() {
        self.presentAlert(title: "Произошла ошибка", text: nil)
    }
    
    @objc private func didTapButton() {
        
        guard let password = passwordTextField.text, let email = emailTextField.text else { return }
        
        guard !email.isEmpty else {
            self.presentAlert(title: "Поле email пустое",
                              text: nil)
            
            return
        }
        
        guard !password.isEmpty else {
            self.presentAlert(title: "Поле пароля пустое",
                              text: nil)
            
            return
        }
        
        guard password.count > 5 else {
            
            self.presentAlert(title: "Длинна пароля всего \(password.count)",
                         text: "Длинна пароля долзна быть не менее 6 символов")
            
            return
        }
        
        logInModel.signIn(email: email,
                          password: password,
                          didComplete: didCompleteSignIn,
                          didNotComplete: didNotCompleteSignIn)
    }
    
    @objc private func keyboadWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                    left: 0,
                                                                    bottom: keyboardSize.height,
                                                                    right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

}
