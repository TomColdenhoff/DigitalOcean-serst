//
//  AccountManager.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 13/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct AccountManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func create(accountName: String) -> Void {
        
        let accountEntity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let newAccount = Account(entity: accountEntity!, insertInto: context)
        newAccount.name = accountName
        
        do {
            try context.save()
        } catch {
            print("Error while saving account, \(error)")
        }
    }
    
    func getAccounts() -> [Account] {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        
        var accounts = [Account]()
        
        do {
            accounts = try context.fetch(fetchRequest) as! [Account]
        } catch {
            print("Error while fetching accounts, \(error)")
        }
        
        return accounts
    }
    
    func delete(account: Account) -> Void {
        do {
            context.delete(account)
            try context.save()
        } catch {
            print("Error while deleting account, \(error)")
        }
    }
}
