//
//  ViewController.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let nextButton = UIButton()
    let updateAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    let config = Config()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNextButton()
        loadConfig()
        view.backgroundColor = UIColor(hex: "#ff4900")?.withAlphaComponent(0.5)
    }

    func loadConfig() {
        config.load { success in
            if success, self.config.showUpdateAlert {
                self.updateAlert.title = self.config.status.title
                self.updateAlert.message = self.config.status.message
                self.updateAlert.addAction(UIAlertAction(title: self.config.status.linkTitle, style: .default, handler: { _ in
                    self.config.handleAlertPress()
                    self.showUpdateAlert()
                }))
                self.showUpdateAlert()
            } else {
                self.config.getPlayableItems { success in
                    if success {
                        print(self.config.playable[0].network.logo_url)
                    }
                }
            }
        }
    }

    func showUpdateAlert() {
        present(updateAlert, animated: true)
    }

    func setUpNextButton() {
        nextButton.backgroundColor = .white
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        nextButton.setTitleColor(.orange, for: .normal)
        nextButton.setTitle("Podcasts", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        view.addSubview(nextButton)
        setupNextButtonConstraints()
    }

    @objc func nextButtonTapped() {
        let nextScreen = PlayableItemsVC(playableItems: config.playable)
        nextScreen.title = "Podcasts"
        navigationController?.pushViewController(nextScreen, animated: true)
    }

    func setupNextButtonConstraints() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
