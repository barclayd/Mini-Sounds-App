//
//  ConfigViewModel.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 09/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import Foundation
import UIKit

struct PullToRefresh {
    var text: String
    var textColour: [NSAttributedString.Key : UIColor]
    var wheelColour: UIColor = .soundsOrange
    var atrributes: NSAttributedString {
        NSAttributedString(string: text, attributes: textColour)
    }
}

class ConfigViewModel {
    var config: Config
    var pullToRefresh: PullToRefresh

    init() {
        self.config = Config()
        self.pullToRefresh = PullToRefresh(text: "Retuning the radio...", textColour: [NSAttributedString.Key.foregroundColor: .black])
    }

    var showUpdateAlert: Bool {
        !(config.status?.isOn ?? true)
    }

    var playableItemsUrl: String {
        "\(config.rms?.rootUrl ?? "")/v2/networks/playable?promoted=true"
    }

    func handleAlertPress() {
        if let url = URL(string: self.config.status.appStoreUrl) {
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

    func load(urlSession: URLSession = URLSession.shared, withCompletion completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: config.appConfigUrl) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        urlSession.dataTask(with: request) { data, _, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.config.status = decodedResponse.status
                        self.config.rms = decodedResponse.rmsConfig
                        completion(true)
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
        }.resume()
    }

    func getPlayableItems(urlSession: URLSession = URLSession.shared, withCompletion completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: self.playableItemsUrl) else {
            print("Invalid URL. Check that load was called to populate the rootUrl")
            return
        }
        let request = URLRequest(url: url)
        guard let apiKey = self.config.rms?.apiKey else {
            print("No api key provided")
            completion(false)
            return
        }
        urlSession.configuration.httpAdditionalHeaders = ["x-api-key": apiKey]
        urlSession.dataTask(with: request) { data, _, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(PlayableResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.config.playable = decodedResponse.data
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
