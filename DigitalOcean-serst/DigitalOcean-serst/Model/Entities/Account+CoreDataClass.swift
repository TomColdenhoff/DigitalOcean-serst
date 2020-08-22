//
//  Account+CoreDataClass.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 13/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//
//

import Foundation
import CoreData
import KeychainAccess

@objc(Account)
public class Account: NSManagedObject {
    
    var apiKey: String? {
        get {
            let keychain = Keychain(service: "com.tomcoldenhoff.\(name!)")
            return try? keychain.get(K.Account.ApiKey)
        }
    }
    
    func setApiKey(key: String) {
        let keychain = Keychain(service: "com.tomcoldenhoff.\(name!)")
        keychain[K.Account.ApiKey] = key
    }
}
