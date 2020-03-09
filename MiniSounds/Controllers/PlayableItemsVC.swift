//
//  PlayableItemsViewController.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 03/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import UIKit

class PlayableItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var configViewModel: ConfigViewModel

    private let refreshControl = UIRefreshControl()

    enum Cells: String {
        case playableItemCell
    }

    init(configVM: ConfigViewModel) {
        self.configViewModel = configVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupPullToRefresh()

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

    func setupPullToRefresh() {
        if #available(iOS 10.0, *) {
            refreshControl.tintColor = configViewModel.pullToRefresh.wheelColour
            refreshControl.attributedTitle = configViewModel.pullToRefresh.attributes
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(refreshPlayableItems(_:)), for: .valueChanged)
    }

    @objc private func refreshPlayableItems(_ sender: Any) {
        configViewModel.getPlayableItems { success in
            if success {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configViewModel.config.playable.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.playableItemCell.rawValue) as! PlayableItemCell
        let playable = configViewModel.config.playable[indexPath.row]
        cell.set(playableViewModel: PlayableViewModel(playable: playable))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playable = configViewModel.config.playable[indexPath.row]
        let nextScreen = PlayerScreen()
        nextScreen.title = playable.titles.primary
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}
