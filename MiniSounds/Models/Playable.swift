//
//  Playable.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 09/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import Foundation

struct Playable: Codable {
    var type: String
    var id: String
    var network: Network
    var titles: Titles
    var duration: Duration
    var image_url: String
}

struct Network: Codable {
    var id: String
    var key: String
    var short_title: String
    var logo_url: String
}

struct Titles: Codable {
    var primary: String
    var secondary: String
    var tertiary: String
}

struct Duration: Codable {
    var label: String
}
