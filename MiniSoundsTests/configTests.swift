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

    func generateMockJSON(isOn: Bool, title: String = "Please Update", message: String = "Download now for the best experience.", linkTitle: String = "Go to store", appStoreUrl: String = "https://itunes.apple.com/us/app/bbc-sounds-radio-podcasts/id1380676511?ls=1&mt=8", apiKey: String = "CMaDBLjA22vTlAevwKqF7c1triBFn6Jk", rootUrl: String = "https://rms.api.bbc.co.uk") -> String {
        """
        {
            "status": {
                "isOn": \(isOn),
                "title" : "\(title)",
                "message" : "\(message)",
                "linkTitle" : "\(linkTitle)",
                "appStoreUrl": "\(appStoreUrl)"
            },
            "rmsConfig": {
                "apiKey": "\(apiKey)",
                "rootUrl": "\(rootUrl)",
            }
        }
        """
    }

    func generateURLSessionMock(jsonString: String) -> URLSession {
        let url = URL(string: "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json")
        URLProtocolMock.testURLs = [url: Data(jsonString.utf8)]
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: configuration)
    }

    func testUpdateAlertIstrueWhenisOnIsFalse() {
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: false))) { success in
            if success {
                XCTAssertTrue(self.config.showUpdateAlert)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testUpdateAlertIsFalseWhenisOnIsTrue() {
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: true))) { success in
            if success {
                XCTAssertFalse(self.config.showUpdateAlert)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testStatusTitleIsPopulatedFromJSON() {
        let title = "Mock title"
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: true, title: title))) { success in
            if success {
                XCTAssertEqual(self.config.status.title, title)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testStatusMessageIsPopulatedFromJSON() {
        let message = "Mock message"
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: true, message: message))) { success in
            if success {
                XCTAssertEqual(self.config.status.message, message)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testStatusLinkTitleIsPopulatedFromJSON() {
        let linkTitle = "Mock link title"
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: true, linkTitle: linkTitle))) { success in
            if success {
                XCTAssertEqual(self.config.status.linkTitle, linkTitle)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testAppStoreURLTitleIsPopulatedFromJSON() {
        let appStoreURL = "https://mock-app-store-url.com"
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: true, appStoreUrl: appStoreURL))) { success in
            if success {
                XCTAssertEqual(self.config.status.appStoreUrl, appStoreURL)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testAPIKeyIsPopulatedFromJSON() {
        let apiKey = "mock-api-key"
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: true, apiKey: apiKey))) { success in
            if success {
                XCTAssertEqual(self.config.rms.apiKey, apiKey)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testRootURLIsPopulatedFromJSON() {
        let rootUrl = "https://mock-rms.api.bbc.co.uk"
        config.load(urlSession: generateURLSessionMock(jsonString: generateMockJSON(isOn: true, rootUrl: rootUrl))) { success in
            if success {
                XCTAssertEqual(self.config.rms.rootUrl, rootUrl)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
