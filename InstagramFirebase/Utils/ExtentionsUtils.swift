//
//  ExtentionsUtils.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/4/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import Foundation
import Firebase
extension Database {
    static func FetchUserWithUID(uid: String, Compeletion: @escaping (User)-> ()){
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (Snapshot) in
            guard let UserDIC = Snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid,dictionary: UserDIC)
            Compeletion(user)
            }) { (error) in
                print("Failed to load Values: ", error.localizedDescription)
            }
    }
}
