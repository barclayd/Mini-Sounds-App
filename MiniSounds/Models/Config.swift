//
//  Config.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import Foundation
import UIKit

enum ConfigError: Error {
    case runtimeError(String)
}

struct Response: Codable {
    var status: Status
    var rmsConfig: RMSConfig
}

struct Status: Codable {
    var isOn: Bool
    var title: String
    var message: String
    var linkTitle: String
    var appStoreUrl: String
}

struct RMSConfig: Codable {
    var apiKey: String
    var rootUrl: String
}

class Config {
    var status: Status!
    var rms: RMSConfig!
    var appConfigUrl = "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json"

    var showUpdateAlert: Bool {
        !(self.status?.isOn ?? true)
    }

    let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func handleAlertPress() {
        if let url = URL(string: self.status.appStoreUrl) {
            #if targetEnvironment(simulator)
                print("The simulator does not support the App Store and so will display 'Safair cannot open the page because the address is invalid.' :(")
            #else
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    if UIApplication.shared.canOpenURL(url as URL) {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
            #endif
        }
    }

    func load(withCompletion completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: appConfigUrl) else {
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
                        completion(true)
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
        }.resume()
    }
}
