//
//  PrometheusManager.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 31/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import Foundation

class PrometheusManager {
    
    let prometheusBaseApiUrl: String
    
    var delegate: PrometheusManagerDelegate?
    
    init(apiUrl: String) {
        prometheusBaseApiUrl = apiUrl
    }
    
    func LoadAllQueries() {
        excecuteCPUFractionQuery()
    }
    
    func excecuteCPUFractionQuery() {
        let currentEpochTimeStamp = NSDate().timeIntervalSince1970
        let epochTimeStampOneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!.timeIntervalSince1970
        
        guard let url = URL(string: prometheusBaseApiUrl + "/api/v1/query_range?query=go_memstats_gc_cpu_fraction&start=\(epochTimeStampOneHourAgo)&end=\(currentEpochTimeStamp)&step=60&_=\(currentEpochTimeStamp)") else { fatalError("Couldn't create url with the string: \(prometheusBaseApiUrl)f/api/v1/query_range?query=go_memstats_gc_cpu_fraction&start=\(epochTimeStampOneHourAgo)&end=\(currentEpochTimeStamp)&step=60&_=\(currentEpochTimeStamp)") }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let safeData = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(PrometheusResponse.self, from: safeData)
                print(response)
                
            } catch {
                print("Error while decoding prometheus response, \(error)")
            }
            
        }
        
        task.resume()
        
    }
}
