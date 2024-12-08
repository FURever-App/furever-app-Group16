//
//  PetsTableViewCell.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import UIKit

class PetsTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelName: UILabel!

    //MARK: declaring the ImageView for receipt image...
    var imageReceipt: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelName()

        //MARK: defining the ImageView for receipt image...
        setupimageReceipt()
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = UIColor(red: 219/255, green: 194/255, blue: 173/255, alpha: 1.0)
        wrapperCellView.layer.cornerRadius = 10.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 6.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont(name: "Sour Gummy", size: 35)
        labelName.textColor = .white
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
 
    //Adding the ImageView for receipt...
    func setupimageReceipt(){
        imageReceipt = UIImageView()
        // we are given imageReceipt a default image view called photo of ios system
        imageReceipt.image = UIImage(systemName: "photo")
        // fill the imageView with the image by resizing it
        imageReceipt.contentMode = .scaleToFill
        // clip the image if it overflows the imageView frame
        imageReceipt.clipsToBounds = true
        imageReceipt.layer.cornerRadius = 10
        imageReceipt.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imageReceipt)
    }
    
    //MARK: initializing the constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                
            imageReceipt.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            imageReceipt.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            //MARK: it is better to set the height and width of an ImageView with constraints...
            imageReceipt.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
            imageReceipt.widthAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
                
            labelName.leadingAnchor.constraint(equalTo: imageReceipt.trailingAnchor, constant: 8),
            labelName.centerYAnchor.constraint(equalTo: imageReceipt.centerYAnchor),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 104)
            
        ])
    }
    
    // Method to update the cell with pet details
    func updateWithPet(pet: Pet) {
        labelName.text = pet.name
        if let photoURL = URL(string: pet.photoURL) {
            loadImage(from: photoURL)
        } else {
            imageReceipt.image = UIImage(systemName: "photo") // Placeholder image
        }
    }

    // Asynchronously load the image from the URL
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.imageReceipt.image = UIImage(systemName: "photo") // Placeholder in case of failure
                }
                return
            }
            DispatchQueue.main.async {
                self.imageReceipt.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    //MARK: unused methods...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
