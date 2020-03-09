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

class configViewModelTests: XCTestCase {
    var configViewModel: ConfigViewModel!
    var expectation: XCTestExpectation!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        configViewModel = ConfigViewModel()
        expectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func mockRMSResponse(isOn: Bool, title: String = "Please Update", message: String = "Download now for the best experience.", linkTitle: String = "Go to store", appStoreUrl: String = "https://itunes.apple.com/us/app/bbc-sounds-radio-podcasts/id1380676511?ls=1&mt=8", apiKey: String = "CMaDBLjA22vTlAevwKqF7c1triBFn6Jk", rootUrl: String = "https://rms.api.bbc.co.uk") -> String {
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

    func mockPlayableItemsResponse() -> String {
        """
        {
        "data": [
            {
                "type": "playable_item",
                "id": "bbc_radio_one",
                "urn": "urn:bbc:radio:network:bbc_radio_one",
                "network": {
                    "id": "bbc_radio_one",
                    "key": "radio1",
                    "short_title": "Radio 1",
                    "logo_url": "https://sounds.files.bbci.co.uk/2.2.4/networks/bbc_radio_one/{type}_{size}.{format}"
                },
                "titles": {
                    "primary": "Clara Amfo",
                    "secondary": "10:00 - 12:45",
                    "tertiary": "03/03/2020"
                },
                "synopses": {
                    "short": "The home of Radio 1's Live Lounge.",
                    "medium": "The home of Radio 1's Live Lounge.",
                    "long": null
                },
                "image_url": "https://ichef.bbci.co.uk/images/ic/{recipe}/p074608w.jpg",
                "duration": {
                    "value": 9900,
                    "label": "165 mins"
                },
                "progress": {
                    "value": 9386,
                    "label": "8 mins left"
                },
                "container": null,
                "download": null,
                "availability": {
                    "from": null,
                    "to": null,
                    "label": "Live"
                },
                "release": {
                    "date": "2020-03-03T00:00:00Z",
                    "label": "03 Mar 2020"
                },
                "guidance": null,
                "activities": [],
                "uris": [],
                "play_context": null
            }
        ]
        }
        """
    }

    func generateURLSessionMock(url: URL? = URL(string: "https://iplayer-radio-mobile-appconfig.files.bbci.co.uk/appconfig/cap/ios/1.6.0/config.json"), jsonString: String) -> URLSession {
        URLProtocolMock.testURLs = [url: Data(jsonString.utf8)]
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]

        return URLSession(configuration: configuration)
    }

    func setRMS() {
        configViewModel.config.rms = RMSConfig(apiKey: "mock-api-key", rootUrl: "https://mock-rms-api.bbc.co.uk")
    }

    func testUpdateAlertIsTrueWhenisOnIsFalse() {
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: false))) { success in
            if success {
                XCTAssertTrue(self.configViewModel.showUpdateAlert)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testUpdateAlertIsFalseWhenisOnIsTrue() {
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: true))) { success in
            if success {
                XCTAssertFalse(self.configViewModel.showUpdateAlert)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testStatusTitleIsPopulatedFromJSON() {
        let title = "Mock title"
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: true, title: title))) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.status.title, title)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testStatusMessageIsPopulatedFromJSON() {
        let message = "Mock message"
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: true, message: message))) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.status.message, message)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testStatusLinkTitleIsPopulatedFromJSON() {
        let linkTitle = "Mock link title"
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: true, linkTitle: linkTitle))) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.status.linkTitle, linkTitle)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testAppStoreURLTitleIsPopulatedFromJSON() {
        let appStoreURL = "https://mock-app-store-url.com"
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: true, appStoreUrl: appStoreURL))) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.status.appStoreUrl, appStoreURL)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testAPIKeyIsPopulatedFromJSON() {
        let apiKey = "mock-api-key"
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: true, apiKey: apiKey))) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.rms.apiKey, apiKey)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testRootURLIsPopulatedFromJSON() {
        let rootUrl = "https://mock-rms.api.bbc.co.uk"
        configViewModel.load(urlSession: generateURLSessionMock(jsonString: mockRMSResponse(isOn: true, rootUrl: rootUrl))) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.rms.rootUrl, rootUrl)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWhenRootUrlAndApiKeyAreSet() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertTrue(success)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectImageUrl() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].image_url, "https://ichef.bbci.co.uk/images/ic/{recipe}/p074608w.jpg")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectDurationLabel() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].duration.label, "165 mins")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectType() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].type, "playable_item")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectPrimaryTitle() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].titles.primary, "Clara Amfo")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectSecondaryTitle() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].titles.secondary, "10:00 - 12:45")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectTertiaryTitle() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].titles.tertiary, "03/03/2020")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectId() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].id, "bbc_radio_one")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectNetworkId() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].network.id, "bbc_radio_one")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectNetworkKey() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].network.key, "radio1")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectNetworkLogoURL() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].network.logo_url, "https://sounds.files.bbci.co.uk/2.2.4/networks/bbc_radio_one/{type}_{size}.{format}")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadsPlayableItemsWithTheCorrectNetworkShortTitle() {
        setRMS()
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertEqual(self.configViewModel.config.playable[0].network.short_title, "Radio 1")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testCannotLoadPlayableItemsWhenRootUrlAndApiKeyAreNotSet() {
        configViewModel.getPlayableItems(urlSession: generateURLSessionMock(url: URL(string: configViewModel.playableItemsUrl), jsonString: mockPlayableItemsResponse())) { success in
            if success {
                XCTAssertFalse(success)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testCorrectPlayableItemsUrlIsGeneratedWhenARootUrlIsSupplied() {
        let rootUrl = "https://mock-rms-api.bbc.co.uk"
        configViewModel.config.rms = RMSConfig(apiKey: "mock-api-key", rootUrl: rootUrl)
        XCTAssertEqual(configViewModel.playableItemsUrl, "\(rootUrl)/v2/networks/playable?promoted=true")
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
}
