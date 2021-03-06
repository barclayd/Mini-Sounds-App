//
//  MiniSoundsUITests.swift
//  MiniSoundsUITests
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import XCTest

class MiniSoundsUITests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppLaunchesToTheCorrectScreen() {
        let app = XCUIApplication()
        app.launch()

        XCTAssert(app.navigationBars["miniSounds"].isHittable)
        XCTAssert(app.buttons["Live Radio"].isHittable)
    }

    func testTappingOnPodcastsButtonTakesUserToSecondScreen() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Live Radio"].tap()
        XCTAssert(app.navigationBars["Live Radio"].isHittable)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
