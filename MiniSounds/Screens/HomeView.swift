//
//  ViewController.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 02/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import UIKit

class HomeView: UIViewController {
    let nextButton = UIButton()
    let updateAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    let configViewModel = ConfigViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNextButton()
        loadConfig()
        view.backgroundColor = UIColor.soundsOrange.withAlphaComponent(0.5)
    }

    func loadConfig() {
        configViewModel.load { success in
            if success, self.configViewModel.showUpdateAlert {
                self.updateAlert.title = self.configViewModel.config.status.title
                self.updateAlert.message = self.configViewModel.config.status.message
                self.updateAlert.addAction(UIAlertAction(title: self.configViewModel.config.status.linkTitle, style: .default, handler: { _ in
                    self.configViewModel.handleAlertPress()
                    self.showUpdateAlert()
                }))
                self.showUpdateAlert()
            } else {
                self.configViewModel.getPlayableItems { success in
                    if success {
                        print("successfully loaded items")
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
        nextButton.setTitle("Live Radio", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        view.addSubview(nextButton)
        setupNextButtonConstraints()
    }

    @objc func nextButtonTapped() {
        if configViewModel.config.playable.count > 0 {
            let nextScreen = PlayableItemsVC(configVM: configViewModel)
            nextScreen.title = "Live Radio"
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }

    func setupNextButtonConstraints() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
