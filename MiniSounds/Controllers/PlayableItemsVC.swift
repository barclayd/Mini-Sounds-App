//
//  PlayableItemsViewController.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 03/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import UIKit

class PlayableItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var playableItems: [Playable]

    enum Cells: String {
        case playableItemCell
    }

    init(playableItems: [Playable]) {
        self.playableItems = playableItems
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(PlayableItemCell.self, forCellReuseIdentifier: Cells.playableItemCell.rawValue)
        tableView.pin(to: view)
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playableItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.playableItemCell.rawValue) as! PlayableItemCell
        let playable = playableItems[indexPath.row]
        cell.set(playable: playable)
        return cell
    }
}
