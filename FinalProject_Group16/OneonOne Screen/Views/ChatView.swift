//
//  ChatView.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/7/24.
//

import UIKit

class ChatView: UIView {
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(IncomingMessageCell.self, forCellReuseIdentifier: "IncomingMessageCell")
        table.register(OutgoingMessageCell.self, forCellReuseIdentifier: "OutgoingMessageCell")
        table.separatorStyle = .none
        table.clipsToBounds = true // Ensure content stays within bounds
        return table
    }()
    
//    let messageInputField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Type a message..."
//        textField.borderStyle = .roundedRect
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
        let messageInputField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Type a message..."
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.textColor = .black
            textField.borderStyle = .roundedRect
            textField.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            textField.layer.cornerRadius = 8.0
            textField.layer.masksToBounds = true

        // Add padding inside the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont(name: "Modak", size: 25)
        button.setTitleColor(
            UIColor(
                red: 207/255.0,
                green: 178/255.0,
                blue: 159/255.0,
                alpha: 255/255.0
            ),
            for: .normal
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
//Handling Keyboard Appearance
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.frame.origin.y = -keyboardFrame.height
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        self.frame.origin.y = 0
    }

    private func setupLayout() {
        addSubview(tableView)
        addSubview(messageInputField)
        addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -10),
            
            messageInputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageInputField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            sendButton.leadingAnchor.constraint(equalTo: messageInputField.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: messageInputField.centerYAnchor)
        ])
    }
}
