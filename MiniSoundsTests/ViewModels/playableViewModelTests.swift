//
//  playableViewModelTests.swift
//  MiniSoundsTests
//
//  Created by Daniel Barclay on 09/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

@testable import MiniSounds
import UIKit
import XCTest

class playableViewModelTests: XCTestCase {
    let initialPlayable = Playable(type: "playable_item", id: "bbc_radio_one", network: Network(id: "bbc_radio_one", key: "radio1", short_title: "Radio 1", logo_url: "https://sounds.files.bbci.co.uk/2.2.4/networks/bbc_radio_one/{type}_{size}.{format}"), titles: Titles(primary: "Radio 1 Breakfast with Greg James", secondary: "06:33 - 10:00", tertiary: "09/03/2020"), duration: Duration(label: "207 mins"), image_url: "https://ichef.bbci.co.uk/images/ic/{recipe}/p06jq8ly.jpg")

    var playableViewModel: PlayableViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        playableViewModel = PlayableViewModel(playable: initialPlayable)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneratesTheCorrectIChefURL() {
        XCTAssertEqual(playableViewModel.iChefUrl, URL(string: "https://ichef.bbci.co.uk/images/ic/320x180/p06jq8ly.jpg"))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
