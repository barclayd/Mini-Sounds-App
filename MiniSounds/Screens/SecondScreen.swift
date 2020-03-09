//
//  SecondScreen.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import SMP
import UIKit

class SecondScreen: UIViewController {
//    let playerItemProvider = BBCSMPMediaSelectorPlayerItemProvider(mediaSet: "apple-iphone4-hls", vpid: "b05x8k76")!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .white

        setUpSMP()
        // Do any additional setup after loading the view.
    }

    func setUpSMP() {
        let playerItemProvider: BBCSMPMediaSelectorPlayerItemProvider = BBCSMPMediaSelectorPlayerItemProvider(mediaSet: "mobile-phone-main", vpid: "bbc_radio_one")
        let player: BBCSMP = BBCSMPPlayerBuilder().withPlayerItemProvider(playerItemProvider)
        player.play()
    }
}
