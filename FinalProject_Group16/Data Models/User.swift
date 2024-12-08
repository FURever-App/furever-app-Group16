//
//  User.swift
//  FinalProject_Group16
//
//  Created by Lu Xu on 12/7/24.
//

struct User: Codable{
    let id: String // 用户的唯一标识符，通常是 Firebase 的用户 ID
    let name: String
    let email: String
}
