//
//  User.swift
//  MasaMoney
//
//  Created by Maria Lopez on 14/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

struct UserProfile {
    var name = ""
    var email = ""
    var pictureURL = ""
}

extension UserProfile {
    init(_ dictionary: [String: Any]) {
        name = dictionary["name"] as! String
        email = dictionary["email"] as! String
        pictureURL = dictionary["profileImageUrl"] as! String
    }
}
