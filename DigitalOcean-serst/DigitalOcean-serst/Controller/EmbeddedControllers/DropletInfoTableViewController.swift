//
//  DropletInfoTableViewController.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 19/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import UIKit

class DropletInfoTableViewController: UITableViewController {

    // If in the future more sections are needed, we should investigate the ability to use reflection to generate the cells instead of hardcoding them.
    var dropletViewModel: Droplet? {
        didSet {
            guard let droplet = dropletViewModel else {
                return
            }
            
            nameLabel?.text = droplet.name
            memoryLabel?.text = "\(droplet.memory)MB"
            DiskLabel?.text = "\(droplet.disk)GB"
            StatusLabel?.text = "\(droplet.status)"
            
            imageNameLabel?.text = droplet.image.name
            imageSlugLabel?.text = droplet.image.slug ?? "N/A"
            
            priceMonthlyLabel?.text = "$\(droplet.size.price_monthly)"
            priceHourlyLabel?.text = "$\(droplet.size.price_hourly)"
            
            let networkV4 = droplet.networks.v4.first
            let networkV6 = droplet.networks.v6.first
            ipv4AddressLabel?.text = networkV4?.ip_address
            ipv4NetmaskLabel?.text = networkV4?.netmask
            ipv4GatewayLabel?.text = networkV4?.gateway
            ipv6AddressLabel?.text = networkV6?.ip_address
            if let netmask = networkV6?.netmask {
                ipv6NetmaskLabel?.text = "\(netmask)"
            }
            ipv6GatewayLabel?.text = networkV6?.gateway
            
            regionNameLabel?.text = droplet.region.name
            regionSlugLabel?.text = droplet.region.slug
        }
    }
    
    //MARK: - Droplet Info
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var memoryLabel: UILabel!
    @IBOutlet weak private var DiskLabel: UILabel!
    @IBOutlet weak private var StatusLabel: UILabel!
    
    //MARK: - Image Info
    @IBOutlet weak private var imageNameLabel: UILabel!
    @IBOutlet weak private var imageSlugLabel: UILabel!
    
    //MARK: - Size Info
    @IBOutlet weak private var priceMonthlyLabel: UILabel!
    @IBOutlet weak private var priceHourlyLabel: UILabel!
    
    //MARK: - Network Info
    @IBOutlet weak private var ipv4AddressLabel: UILabel!
    @IBOutlet weak private var ipv4NetmaskLabel: UILabel!
    @IBOutlet weak private var ipv4GatewayLabel: UILabel!
    @IBOutlet weak private var ipv6AddressLabel: UILabel!
    @IBOutlet weak private var ipv6NetmaskLabel: UILabel!
    @IBOutlet weak private var ipv6GatewayLabel: UILabel!
    
    //MARK: - Region Info
    @IBOutlet weak private var regionNameLabel: UILabel!
    @IBOutlet weak private var regionSlugLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.backgroundColor = .clear; //In light mode the background was visible, fixed with code
        
        //Retrigger DidSet, because segue calls before initialized IBOutlets
        let tempDroplet = dropletViewModel
        dropletViewModel = tempDroplet
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
