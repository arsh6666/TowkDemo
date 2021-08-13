//
//  User.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import Foundation

// MARK: - User
struct User: Codable {
    let login,name: String?
    let id,follower,following: Int?
    let avatarURL: String?
    let type,blog,company: String?
    let siteAdmin: Bool?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id,blog,company,name
        case avatarURL = "avatar_url"
        case type,notes,follower,following
        case siteAdmin = "site_admin"
    }
}
