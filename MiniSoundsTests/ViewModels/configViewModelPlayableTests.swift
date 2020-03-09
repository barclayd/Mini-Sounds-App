//
//  configViewModelPlayableTests.swift
//  MiniSoundsTests
//
//  Created by Daniel Barclay on 09/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

@testable import MiniSounds
import UIKit
import XCTest

class configViewModelPlayableTests: XCTestCase {
    var configViewModel: ConfigViewModel!

    override func setUp() {
        configViewModel = ConfigViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCorrectPlayableItemsUrlIsGeneratedWhenARootUrlIsSupplied() {
        let rootUrl = "https://mock-rms-api.bbc.co.uk"
        configViewModel.config.rms = RMSConfig(apiKey: "mock-api-key", rootUrl: rootUrl)
        XCTAssertEqual(configViewModel.playableItemsUrl, "\(rootUrl)/v2/networks/playable?promoted=true")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
