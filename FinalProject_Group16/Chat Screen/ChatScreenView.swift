//
//  ChatScreenView.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/6/24.
//

import UIKit

class ChatScreenView: UIView {
    var labelText: UILabel!
    var tableViewChats: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLabelText()
        setupTableViewChats()
        setupConstraints()
    }
    

    private func setupLabelText() {
        labelText = UILabel()
        labelText.text = "Chats" // Placeholder text, can be set dynamically later
        labelText.font = UIFont(name: "Modak", size: 40)
        labelText.textColor = UIColor(
            red: 207 / 255.0,
            green: 178 / 255.0,
            blue: 159 / 255.0,
            alpha: 1.0 // Alpha value is in the range of 0 to 1
        )
        labelText.textAlignment = .left
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    private func setupTableViewChats() {
        tableViewChats = UITableView()
        tableViewChats.register(ChatsTableViewCell.self, forCellReuseIdentifier: Configs.TableView.chatsCellIdentifier)
        tableViewChats.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChats)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelText.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            labelText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            tableViewChats.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 10),
            tableViewChats.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableViewChats.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableViewChats.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

