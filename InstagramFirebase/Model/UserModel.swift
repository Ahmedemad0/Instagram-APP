//
//  UserModel.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/2/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let ProfileImageURL: String
    let uid: String
    init(uid: String,dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? " "
        self.ProfileImageURL = dictionary["ProfileImageURL"] as? String ?? " "
    }
}
