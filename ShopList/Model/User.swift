//
//  User.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation

struct User:Codable{
    let id: Int
    let email: String
    let username: String
    let password: String
}
