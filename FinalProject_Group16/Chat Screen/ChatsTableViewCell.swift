//
//  ChatsTableViewCell.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/6/24.
//
//
import UIKit

class ChatsTableViewCell: UITableViewCell {
    private let wrapperCellView = UIView()
    private let labelName = UILabel()
    private let labelMessage = UILabel()
    private let labelDate = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrapperCellView)
        
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
        
        labelMessage.font = UIFont.systemFont(ofSize: 14)
        labelMessage.textColor = .darkGray
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessage)
        
        labelDate.font = UIFont.systemFont(ofSize: 12)
        labelDate.textColor = .gray
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDate)
    }
    
    func configure(with chat: Chat) {
        labelName.text = chat.otherUserName
        labelMessage.text = "\(chat.lastUser): \(chat.lastMessage)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        labelDate.text = formatter.string(from: chat.dateTime)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wrapperCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            wrapperCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            wrapperCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            
            labelMessage.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            labelMessage.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            labelDate.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 4),
            labelDate.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelDate.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            labelDate.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8)
        ])
    }
}
