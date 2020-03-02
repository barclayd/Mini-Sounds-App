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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNextButton()
        view.backgroundColor = .red
    }

    func setUpNextButton() {
        nextButton.backgroundColor = .white
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.setTitle("Next", for: .normal)

        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        view.addSubview(nextButton)
        setupNextButtonConstraints()
    }

    @objc func nextButtonTapped() {
        let nextScreen = SecondScreen()
        nextScreen.title = "Podcasts"
        navigationController?.pushViewController(nextScreen, animated: true)
    }

    func setupNextButtonConstraints() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
