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

//        setUpSMP()
        // Do any additional setup after loading the view.
    }

//    func setUpSMP() {
//        let playerFrame: CGRect = CGRect(x: 50, y: 100, width: 200, height: 200)
//        let brand: BBCSMPBrand = BBCSMPBrand()
//        let player: BBCSMP = BBCSMPPlayerBuilder().withPlayerItemProvider(playerItemProvider).build()
//        let playerView = player.buildUserInterface().withFrame(playerFrame).withBrand(brand).buildView()
//
//        view.addSubview(playerView)
//    }
}
