//
//  Account.swift
//  MasaMoney
//
//  Created by Maria Lopez on 02/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import MobileCoreServices

// Necessary to be like this to be able to drag it (NSObject)

final class Account: NSObject, NSItemProviderWriting, NSItemProviderReading, Codable {
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        //We know that we want to represent our object as a data type, so we'll specify that
        return [(kUTTypeData as String)]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        do {
            //Here the object is encoded to a JSON data object and sent to the completion handler
            let data = try JSONEncoder().encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return progress
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        //We know we want to accept our object as a data representation, so we'll specify that here
        return [(kUTTypeData) as String]
    }
    
    //This function actually has a return type of Self, but that really messes things up when you are trying to return your object, so if you mark your class as final as I've done above, the you can change the return type to return your class type.
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Account {
        let decoder = JSONDecoder()
        do {
            //Here we decode the object back to it's class representation and return it
            let account = try decoder.decode(Account.self, from: data)
            return account
        } catch {
            fatalError(error as! String)
        }
    }
    
    var id = ""
    var name = ""
    var icon = ""
    var balance = 0.0
    var income = true
    
    override init() {
        super.init()
    }
}
