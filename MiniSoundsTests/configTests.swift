//
//  configTests.swift
//  MiniSoundsTests
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

@testable import MiniSounds
import UIKit
import XCTest

class configTests: XCTestCase {
    var config: Config!
    var expectation: XCTestExpectation!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        config = Config()
        expectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateAlertIstrueWhenisOnIsFalse() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let jsonString = """
        {
            "status": {
                "isOn": false,
                "title" : "Please Update",
                "message" : "Download now for the best experience.",
                "linkTitle" : "Go to store",
                "appStoreUrl": "https://itunes.apple.com/us/app/bbc-sounds-radio-podcasts/id1380676511?ls=1&mt=8"
            },
            "rmsConfig": {
                "apiKey": "CMaDBLjA22vTlAevwKqF7c1triBFn6Jk",
                "rootUrl": "https://rms.api.bbc.co.uk",
            }
        }
        """
        let url = URL(string: "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json")

        URLProtocolMock.testURLs = [url: Data(jsonString.utf8)]
        print(URLProtocolMock.testURLs)

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]

        let session = URLSession(configuration: configuration)

        config.load(urlSession: session) { success in
            print(success)
            if success {
                XCTAssertTrue(self.config.showUpdateAlert)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testUpdateAlertIsFalseWhenisOnIsTrue() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let jsonString = """
        {
            "status": {
                "isOn": true,
                "title" : "Please Update",
                "message" : "Download now for the best experience.",
                "linkTitle" : "Go to store",
                "appStoreUrl": "https://itunes.apple.com/us/app/bbc-sounds-radio-podcasts/id1380676511?ls=1&mt=8"
            },
            "rmsConfig": {
                "apiKey": "CMaDBLjA22vTlAevwKqF7c1triBFn6Jk",
                "rootUrl": "https://rms.api.bbc.co.uk",
            }
        }
        """
        let url = URL(string: "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json")

        URLProtocolMock.testURLs = [url: Data(jsonString.utf8)]
        print(URLProtocolMock.testURLs)

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]

        let session = URLSession(configuration: configuration)

        config.load(urlSession: session) { success in
            print(success)
            if success {
                XCTAssertFalse(self.config.showUpdateAlert)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
