//
//  IncomingMessageCell.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/7/24.
//

import UIKit


class IncomingMessageCell: UITableViewCell {
    
    private let senderLabel = UILabel()
    private let messageLabel = UILabel()
    private let timestampLabel = UILabel()
    private let bubbleView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    func setupLabelTitle(){
//        labelTitle = UILabel()
//        labelTitle.text = "My Furry Friends"
//        labelTitle.font = UIFont(name: "Modak", size: 34)
//        labelTitle.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(labelTitle)
//    }

    
    
    private func setupUI() {
        senderLabel.font = UIFont.systemFont(ofSize: 14)
        senderLabel.textColor = .black
        senderLabel.font = UIFont(name: "SourGummy", size: 20)
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        
        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.textColor = .gray
        //    chatButton.setTitleColor(
        //        UIColor(
        //            red: 207/255.0,
        //            green: 178/255.0,
        //            blue: 159/255.0,
        //            alpha: 255/255.0
        //        ),
        //        for: .normal
        //    )
        bubbleView.backgroundColor = UIColor.systemGray5
        bubbleView.layer.cornerRadius = 18
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)
        
        let stackView = UIStackView(arrangedSubviews: [senderLabel, messageLabel, timestampLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        bubbleView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
            
            stackView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with message: Message) {
        senderLabel.text = message.senderName // 使用发送者的名字
        messageLabel.text = message.text
        timestampLabel.text = formatDate(message.createdAt)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
