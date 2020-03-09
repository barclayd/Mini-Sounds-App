//
//  configViewModelPullToRefresh.swift
//  MiniSoundsTests
//
//  Created by Daniel Barclay on 09/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

@testable import MiniSounds
import UIKit
import XCTest

class configViewModelPullToRefresh: XCTestCase {
    var configViewModel: ConfigViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        configViewModel = ConfigViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPullToRefeshHasTheCorrectText() {
        XCTAssertEqual(configViewModel.pullToRefresh.text, "Retuning the radio...")
    }

    func testPullToRefeshHasTheCorrectAttributes() {
        XCTAssertEqual(configViewModel.pullToRefresh.attributes, NSAttributedString(string: configViewModel.pullToRefresh.text, attributes: configViewModel.pullToRefresh.textColour))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
