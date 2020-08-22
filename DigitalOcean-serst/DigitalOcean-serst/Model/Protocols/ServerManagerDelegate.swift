//
//  ServerManagerDelegate.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 16/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

protocol ServerManagerDelegate {
    func serverManager(_ serverManager: ServerManager, didLoadDroplets droplets: Droplets)
}
