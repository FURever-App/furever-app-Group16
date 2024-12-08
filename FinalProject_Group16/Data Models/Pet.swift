//
//  Pet.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//
import Foundation
import FirebaseFirestore

import Foundation
import FirebaseFirestore

struct Pet: Codable {
    @DocumentID var id: String?
    
    var photoURL: String
    var type: PetType
    var name: String
    var age: Int
    var sex: PetSex
    var weight: Int
    var breed: String
    var color: String
    var isSpayedOrNeutered: Bool
    var additionalInfo: String?
    var ownerEmail: String?
    
    init(photoURL: String,
         type: PetType,
         name: String,
         age: Int,
         sex: PetSex,
         weight: Int,
         breed: String,
         color: String,
         isSpayedOrNeutered: Bool,
         additionalInfo: String? = nil,
         ownerEmail:String? = nil) {
        self.photoURL = photoURL
        self.type = type
        self.name = name
        self.age = age
        self.sex = sex
        self.weight = weight
        self.breed = breed
        self.color = color
        self.isSpayedOrNeutered = isSpayedOrNeutered
        self.additionalInfo = additionalInfo
        self.ownerEmail = ownerEmail
    }
    
    // Custom initializer with id
    init(id: String?,
         photoURL: String,
         type: PetType,
         name: String,
         age: Int,
         sex: PetSex,
         weight: Int,
         breed: String,
         color: String,
         isSpayedOrNeutered: Bool,
         additionalInfo: String? = nil, ownerEmail:String? = nil) {
        self.id = id
        self.photoURL = photoURL
        self.type = type
        self.name = name
        self.age = age
        self.sex = sex
        self.weight = weight
        self.breed = breed
        self.color = color
        self.isSpayedOrNeutered = isSpayedOrNeutered
        self.additionalInfo = additionalInfo
        self.ownerEmail = ownerEmail

    }
}

// Enum for Pet Type (Dog or Cat)
enum PetType: String, Codable {
    case dog = "Dog"
    case cat = "Cat"
}

// Enum for Pet Sex (Male or Female)
enum PetSex: String, Codable {
    case male = "Male"
    case female = "Female"
}
