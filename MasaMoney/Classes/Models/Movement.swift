//
//  Movement.swift
//  MasaMoney
//
//  Created by Maria Lopez on 20/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

struct Movement {
    var origin = ""
    var destination = ""
    var amount = 0.0
    var addition = ""
    var date = ""
    var comment : String?
    var picture : String?
}

extension Movement {
    init(_ dictionary: [String: Any]) {
        origin = dictionary["origin"] as! String
        destination = dictionary["destination"] as! String
        amount = dictionary["amount"] as! Double
        addition = dictionary["addition"] as! String
        date = dictionary["date"] as! String
        comment = dictionary["comment"] as? String
        picture = dictionary["picture"] as? String
    }
}
