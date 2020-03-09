//
//  Playable.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 09/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import Foundation

struct Playable: Codable {
    let iChefRecipe = "320x180"

    var iChefUrl: URL? {
        URL(string: image_url.replacingOccurrences(of: "{recipe}", with: iChefRecipe))
    }

    var type: String
    var id: String
    var network: Network
    var titles: Titles
    var duration: Duration
    var image_url: String
}
