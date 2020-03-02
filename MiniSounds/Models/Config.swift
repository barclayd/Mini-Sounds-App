//
//  Config.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import Foundation

struct Response: Codable {
    var status: Status
    var rmsConfig: RMSConfig
}

struct Status: Codable {
    var isOn: Bool
}

struct RMSConfig: Codable {
    var apiKey: String
    var rootUrl: String
}

class Config {
    var status: Status!
    var rms: RMSConfig!

    var showUpdateAlert: Bool {
        !(self.status?.isOn ?? true)
    }

    init() {}

    func load(withCompletion completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.status = decodedResponse.status
                        self.rms = decodedResponse.rmsConfig
                    }
                    completion(true)
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
        }.resume()
    }
}
