//
//  PostsModel.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/1/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import Foundation
struct Post {
    let user: User
    let imageURL: String
    let Caption: String
    let Creation_Date: Date
    init(user: User,dictionary: [String: Any]){
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.Caption  = dictionary["Caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["Creation_Date"] as? Double ?? 0
        self.Creation_Date = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
