//
//  MainScreenView.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit

class MainScreenView: UIView {
    
    var labelTitle: UILabel!
    var labelText: UILabel!
    var floatingButtonAddPet: UIButton!
    var tableViewPets: UITableView!
    var chatButton: UIButton!
    var findDateButton: UIButton!
    var mapButton: UIButton!
    var separatorLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLabelTitle()
        setupLabelText()
        setupFloatingButtonAddPet()
        setupTableViewContacts()
        setupSeparatorLine()
        setupBottomButtons()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupLabelTitle(){
        labelTitle = UILabel()
        labelTitle.text = "My Furry Friends"
        labelTitle.font = UIFont(name: "Modak", size: 34)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = UIFont(name: "Delius Unicase", size: 16)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupTableViewContacts(){
        tableViewPets = UITableView()
        tableViewPets.register(PetsTableViewCell.self, forCellReuseIdentifier: "pets")
        tableViewPets.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewPets)
    }
    
    func setupFloatingButtonAddPet(){
        floatingButtonAddPet = UIButton(type: .system)
        floatingButtonAddPet.setTitle("", for: .normal)
        floatingButtonAddPet.setImage(UIImage(named: "paw-print")?.withRenderingMode(.alwaysOriginal), for: .normal)
        floatingButtonAddPet.contentHorizontalAlignment = .fill
        floatingButtonAddPet.contentVerticalAlignment = .fill
        floatingButtonAddPet.imageView?.contentMode = .scaleAspectFit
        floatingButtonAddPet.layer.cornerRadius = 16
        floatingButtonAddPet.imageView?.layer.shadowOffset = .zero
        floatingButtonAddPet.imageView?.layer.shadowRadius = 0.8
        floatingButtonAddPet.imageView?.layer.shadowOpacity = 0.7
        floatingButtonAddPet.imageView?.clipsToBounds = true
        floatingButtonAddPet.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonAddPet)
    }
    
    func setupSeparatorLine() {
        separatorLine = UIView()
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)
    }
    
    func setupBottomButtons() {
        chatButton = UIButton(type: .system)
        chatButton.setTitle("Chat", for: .normal)
        chatButton.setTitleColor(
            UIColor(
                red: 207/255.0,
                green: 178/255.0,
                blue: 159/255.0,
                alpha: 255/255.0
            ),
            for: .normal
        )
        chatButton.titleLabel?.font = UIFont(name: "Modak", size: 28)
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chatButton)
        
        findDateButton = UIButton(type: .system)
        findDateButton.setTitle("Find My Date", for: .normal)
        findDateButton.setTitleColor(
            UIColor(
                red: 207/255.0,
                green: 178/255.0,
                blue: 159/255.0,
                alpha: 255/255.0
            ),
            for: .normal
        )
        findDateButton.titleLabel?.font = UIFont(name: "Modak", size: 28)
        findDateButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(findDateButton)
        
        mapButton = UIButton(type: .system)
        mapButton.setTitle("Map", for: .normal)
        mapButton.setTitleColor(
            UIColor(
                red: 207/255.0,
                green: 178/255.0,
                blue: 159/255.0,
                alpha: 255/255.0
            ),
            for: .normal
        )
        mapButton.titleLabel?.font = UIFont(name: "Modak", size: 28)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapButton)
    }
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            // Label Text
            labelText.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            labelText.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelTitle.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 16),
            
            // TableView
            tableViewPets.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            tableViewPets.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -8),
            tableViewPets.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewPets.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Separator Line
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: chatButton.topAnchor, constant: -8),
            
            // Chat Button
            chatButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            chatButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            
            // Find My Date Button
            findDateButton.centerYAnchor.constraint(equalTo: chatButton.centerYAnchor),
            findDateButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Map Button
            mapButton.centerYAnchor.constraint(equalTo: chatButton.centerYAnchor),
            mapButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            // Floating Button
            floatingButtonAddPet.widthAnchor.constraint(equalToConstant: 48),
            floatingButtonAddPet.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonAddPet.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -8),
            floatingButtonAddPet.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
