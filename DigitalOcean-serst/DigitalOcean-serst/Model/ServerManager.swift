//
//  ServerManager.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 15/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import Foundation

class ServerManager {
    
    var delegate: ServerManagerDelegate?
    
    func fetchServers(apiKey: String) {
        guard let url = URL(string: K.DigitalOceanApi.DropletApiUrl) else { fatalError("Couldn't create url with the string: \(K.DigitalOceanApi.DropletApiUrl)") }
        
        let sessionConfig = URLSessionConfiguration.default
        let authValue = "Bearer \(apiKey)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authValue]
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let safeData = data else { fatalError("Couldn't load data") }
            
            let decoder = JSONDecoder()
            do {
                let droplets = try decoder.decode(Droplets.self, from: safeData)
                self.delegate?.serverManager(self, didLoadDroplets: droplets)
            } catch {
                print("Error while decoding droplets, \(error)")
            }
        }
        
        task.resume()
        
    }
}
