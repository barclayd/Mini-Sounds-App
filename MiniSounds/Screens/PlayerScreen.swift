//
//  SecondScreen.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import SMP
import UIKit

class PlayerScreen: UIViewController {
    var player: BBCSMP!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .white
        
        setUpSMP()
        player.play()
        // Do any additional setup after loading the view.
    }
    
    func setUpSMP() {
        guard let playerItemProvider = BBCSMPBackingOffMediaSelectorPlayerItemProvider(mediaSelectorClient: MediaSelectorClient(), mediaSet: "mobile-phone-main", vpid: "bbc_radio_one", artworkFetcher: nil, blacklist: TimeBasedBlacklist(blacklistInterval: 0), connectionResolver: TimeBasedConnectionResolver(), avStatisticsConsumer: AVStatisticsConsumer()) else {
            return
        }
        player = BBCSMPPlayerBuilder().withPlayerItemProvider(playerItemProvider).build()
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
