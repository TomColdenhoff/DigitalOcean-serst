//
//  K.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 13/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

struct K {
    struct Account {
        static let TableCell = "AccountTableCell"
        static let ToServersSegue = "goToServers"
        static let ApiKey = "apiKey"
    }

    struct DigitalOceanApi {
        static let DropletApiUrl = "https://api.digitalocean.com/v2/droplets"
    }
    
    struct Servers {
        static let TableViewName = "DropletTableViewCell"
        static let TableCellId = "DropletTableCell"
        static let ToDropletSegue = "goToServer"
    }
    
    struct Server {
        static let EmbeddedDropletInfoSegue = "dropletInfoSegue"
    }
}
