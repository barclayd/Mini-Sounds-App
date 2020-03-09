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

struct PlayableResponse: Codable {
    var data: [Playable]
}

class Config {
    var status: Status!
    var rms: RMSConfig!
    var playable: [Playable]!
    let appConfigUrl = "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json"
}
