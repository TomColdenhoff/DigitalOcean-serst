//
//  Server.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 15/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import Foundation

struct Droplets: Decodable {
    let droplets: [Droplet]
}

struct Droplet: Decodable {
    let name: String
    let memory: Int
    let vcpus: Int
    let disk: Int
    let status: String
    let image: Image
    let size: Size
    let networks: Networks
    let region: Region
}

struct Image: Decodable {
    let name: String
    let slug: String?
}

struct Size: Decodable {
    let price_monthly: Double
    let price_hourly: Double
}

struct Networks: Decodable {
    let v4: [V4]
    let v6: [V6]
}

struct V4: Decodable {
    let ip_address: String
    let netmask: String
    let gateway: String
}

struct V6: Decodable {
    let ip_address: String
    let netmask: Int
    let gateway: String
}

struct Region: Decodable {
    let name: String
    let slug: String
}
