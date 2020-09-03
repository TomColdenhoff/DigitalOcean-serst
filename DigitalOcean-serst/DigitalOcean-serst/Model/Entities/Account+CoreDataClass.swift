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
    
    func setCachedDroplets(droplets: [Droplet]) {
        let cachedDropletsSet = cachedDroplets as! Set<CachedDroplet>
        let notNeededDroplets = cachedDropletsSet.filter({cachedDroplet in !droplets.contains(where: {droplet in droplet.name == cachedDroplet.dropletName})})
        let newDroplets = droplets.filter({droplet in !cachedDropletsSet.contains(where: {cachedDroplet in cachedDroplet.dropletName == droplet.name})})
        for droplet in notNeededDroplets {
            
            managedObjectContext?.delete(droplet)
        }
        
        newDroplets.forEach {
            droplet in
            
            let cachedDropletEntity = NSEntityDescription.entity(forEntityName: "CachedDroplet", in: managedObjectContext!)
            let newCachedDroplet = CachedDroplet(entity: cachedDropletEntity!, insertInto: managedObjectContext)
            newCachedDroplet.dropletName = droplet.name
            setValue(NSSet(object: newCachedDroplet), forKey: "cachedDroplets")
        }
        
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error while saving cachedDroplets, \(error)")
        }
        
    }
    
    func getCachedDroplet(droplet: Droplet) -> CachedDroplet? {
        
        return (cachedDroplets as! Set<CachedDroplet>).first { (cachedDroplet) -> Bool in
            return cachedDroplet.dropletName == droplet.name
        }
    }
}

