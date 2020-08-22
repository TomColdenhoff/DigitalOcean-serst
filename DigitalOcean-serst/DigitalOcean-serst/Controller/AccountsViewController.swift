//
//  AccountsViewController.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 13/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import UIKit
import SwipeCellKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var accountsTableView: UITableView!
    private var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTableViewData()
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        presentAddAccountAlert()
    }
    
    private func presentAddAccountAlert() {
        var accountNameTextField = UITextField()
        let addAccountAlert = UIAlertController(title: "Add an account", message: "Enter a name for your account.", preferredStyle: .alert)
        addAccountAlert.addTextField { (textField) in
            
            textField.placeholder = "For example: Private Account or Work Account"
            accountNameTextField = textField
            
        }
        
        let addAccountAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            guard let accountName = accountNameTextField.text, !accountNameTextField.text!.isEmpty else {
                self.presentErrorAlert(message: "Account name can't be empty")
                return
            }
            
            self.saveAccount(accountName: accountName)
            self.reloadTableViewData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addAccountAlert.addAction(addAccountAction)
        addAccountAlert.addAction(cancelAction)
        
        present(addAccountAlert, animated: true)
        
    }
    
    private func presentErrorAlert(message: String) {
        
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let closeErrorAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        errorAlert.addAction(closeErrorAction)
        present(errorAlert, animated: true)
        
    }
    
    private func saveAccount(accountName: String) {
        AccountManager().create(accountName: accountName)
    }
    
    private func reloadTableViewData() {
        accounts = AccountManager().getAccounts()
        accountsTableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard segue.identifier == K.Account.ToServersSegue else {
            fatalError("Unknown segue for AccountsViewController")
        }
        
        let serversViewController = segue.destination as! ServersViewController
        
        if let indexPath = accountsTableView.indexPathForSelectedRow {
            serversViewController.account = accounts[indexPath.row]
        }
    }

}

//MARK: - Tableview
extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Account.TableCell, for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = accounts[indexPath.row].name
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: K.Account.ToServersSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - SwipeTableView

extension AccountsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            AccountManager().delete(account: self.accounts[indexPath.row])
            self.accounts.remove(at: indexPath.row)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.transitionStyle = .border
        return options
    }
    
}
