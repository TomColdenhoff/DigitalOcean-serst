//
//  CachedDroplet+CoreDataClass.swift
//  
//
//  Created by Tom Coldenhoff on 23/08/2020.
//
//

import Foundation
import CoreData

@objc(CachedDroplet)
public class CachedDroplet: NSManagedObject {
    func setPrometheusApiUrl(_ url: String) {
        prometheusApiUrl = url
        
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error while saving cached droplet, \(error) ")
        }
        
    }
}
