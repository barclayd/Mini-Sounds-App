//
//  PlayerScreen.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import SMP
import UIKit

class PlayerScreen: UIViewController {
    var player: BBCSMP!
    var network: Network
    
    init(network: Network) {
        self.network = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .white
        
        setUpSMP()
        player.play()
        // Do any additional setup after loading the view.
    }
    
    func setUpSMP() {
        let mediaSelector = MediaSelectorItemProviderBuilder(VPID: network.id,
                                                             mediaSet: "mobile-phone-main", AVType: .audio, streamType: .VOD, avStatisticsConsumer: AVStatisticsConsumer())
        player = BBCSMPPlayerBuilder().withPlayerItemProvider(mediaSelector.buildItemProvider()).build()
    }
}

class AVStatisticsConsumer: NSObject, BBCSMPAVStatisticsConsumer {
    func trackAVSessionStart(itemMetadata: BBCSMPItemMetadata!) {}
    
    func trackAVFullMediaLength(lengthInSeconds mediaLengthInSeconds: Int) {}
    
    func trackAVPlayback(currentLocation: Int, customParameters: [AnyHashable: Any]!) {}
    
    func trackAVPlaying(subtitlesActive: Bool, playlistTime: Int, assetTime: Int, currentLocation: Int, assetDuration: Int) {}
    
    func trackAVBuffer(playlistTime: Int, assetTime: Int, currentLocation: Int) {}
    
    func trackAVPause(playlistTime: Int, assetTime: Int, currentLocation: Int) {}
    
    func trackAVResume(playlistTime: Int, assetTime: Int, currentLocation: Int) {}
    
    func trackAVScrub(from fromTime: Int, to toTime: Int) {}
    
    func trackAVEnd(subtitlesActive: Bool, playlistTime: Int, assetTime: Int, assetDuration: Int, wasNatural: Bool, customParameters: [AnyHashable: Any]!) {}
    
    func trackAVSubtitlesEnabled(_ subtitlesEnabled: Bool) {}
    
    func trackAVPlayerSizeChange(_ playerSize: CGSize) {}
    
    func trackAVError(_ errorString: String!, playlistTime: Int, assetTime: Int, currentLocation: Int, customParameters: [AnyHashable: Any]!) {}
}
