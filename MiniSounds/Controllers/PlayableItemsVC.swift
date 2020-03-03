//
//  PlayableItemsViewController.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 03/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import UIKit

class PlayableItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.pin(to: view)
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
