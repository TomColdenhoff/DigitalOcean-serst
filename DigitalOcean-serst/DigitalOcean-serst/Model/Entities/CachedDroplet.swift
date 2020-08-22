//
//  CachedDroplet.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 21/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import UIKit
import CoreData

@objc(CachedDroplet)
public class CachedDroplet: NSManagedObject {

    @NSManaged public var dropletName: String?
    @NSManaged public var account: Account
    
}
