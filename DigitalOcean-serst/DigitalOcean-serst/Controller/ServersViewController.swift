//
//  ServersViewController.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 13/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import UIKit
import ContentLoader

class ServersViewController: UIViewController {

    var account: Account?
    let serverManager = ServerManager()
    var droplets = [Droplet]()
    
    @IBOutlet weak var dropletsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if account!.apiKey == nil {
            showApiInputAlert()
        }
        
        serverManager.delegate = self
        dropletsTableView.register(UINib(nibName: K.Servers.TableViewName, bundle: nil), forCellReuseIdentifier: K.Servers.TableCellId)
        dropletsTableView.delegate = self
        dropletsTableView.dataSource = self
        
        var format = ContentLoaderFormat()
        format.color = UIColor.lightGray
        format.radius = 5
        format.animation = .fade
        
        dropletsTableView.startLoading(format: format)
        fetchServers()
    }
    
    private func showApiInputAlert() {
        var textField = UITextField()
        
        let apiKeyAlert = UIAlertController(title: "API key", message: "We need your DigitalOcean api key", preferredStyle: .alert)
        apiKeyAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "api key"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard !textField.text!.isEmpty else { self.presentErrorAlert(message: "You need to enter an api key"); return}
            self.account!.setApiKey(key: textField.text!)
            self.fetchServers()
        }
        
        apiKeyAlert.addAction(addAction)
        
        present(apiKeyAlert, animated: true)
    }
    
    private func presentErrorAlert(message: String) {
        
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let closeErrorAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        errorAlert.addAction(closeErrorAction)
        present(errorAlert, animated: true)
        
    }
    
    private func fetchServers() {
        guard let apiKey = account!.apiKey else { return }
        
        serverManager.fetchServers(apiKey: apiKey)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard segue.identifier == K.Servers.ToDropletSegue else {
            fatalError("Unknown segue for ServersViewController")
        }
        
        let serverViewController = segue.destination as! ServerViewController
        
        if let index = dropletsTableView.indexPathForSelectedRow?.row {
                serverViewController.droplet = droplets[index]
        }
    }

}

extension ServersViewController: ServerManagerDelegate {
    
    func serverManager(_ serverManager: ServerManager, didLoadDroplets droplets: Droplets) {
        self.droplets = droplets.droplets
        
        DispatchQueue.main.async {
            self.dropletsTableView.hideLoading()
            self.dropletsTableView.reloadData()
        }
    }
}

extension ServersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return droplets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dropletsTableView.dequeueReusableCell(withIdentifier: K.Servers.TableCellId, for: indexPath) as! DropletTableViewCell
        cell.dropletViewModel = droplets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Servers.ToDropletSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ServersViewController: ContentLoaderDataSource {
    
    func numSections(in contentLoaderView: UIView) -> Int {
        return 1
    }

    func contentLoaderView(_ contentLoaderView: UIView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func contentLoaderView(_ contentLoaderView: UIView, cellIdentifierForItemAt indexPath: IndexPath) -> String {
        return K.Servers.TableCellId
    }
}
