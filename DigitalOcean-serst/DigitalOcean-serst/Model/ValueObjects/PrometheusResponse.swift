//
//  PrometheusResponse.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 31/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

// MARK: - PrometheusResponse
struct PrometheusResponse: Decodable {
    let status: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let result: [Result]
}

// MARK: - Result
struct Result : Decodable {

        let values : [[DoubleOrString]]?
}

struct DoubleOrString: Decodable {
    var value: Any

    init(from decoder: Decoder) throws {
        if let double = try? Double(from: decoder) {
            value = double
            return
        }
        
        value = try String(from: decoder)
    }
}
