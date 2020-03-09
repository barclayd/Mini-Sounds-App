//
//  PlayableViewModel.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 09/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import Foundation
import UIKit

class PlayableViewModel {
    var playable: Playable

    init(playable: Playable) {
        self.playable = playable
    }

    let iChefRecipe = "320x180"
    let placeholderImage = UIImage(named: "sounds")

    var iChefUrl: URL? {
        URL(string: playable.image_url.replacingOccurrences(of: "{recipe}", with: iChefRecipe))
    }
}
