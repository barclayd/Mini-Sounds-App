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

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let urlSession = URLSession(configuration: configuration)
        config = Config(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetShowUpdateAlertIsTrueWhenisOnResponseIsFalse() {
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
        let data = Data(jsonString.utf8)

        URLProtocolStub.requestHandler = { request in
            let dataUrl = URL(string: "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json")!
            guard let url = request.url, url == dataUrl else {
                throw ConfigError.runtimeError("Could not proceed")
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        config.load { success in
            if success {
                XCTAssertEqual(self.config.showUpdateAlert, false)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
