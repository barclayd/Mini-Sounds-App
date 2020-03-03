//
//  PlayableItemCell.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 03/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import UIKit

class PlayableItemCell: UITableViewCell {
    var itemImageView = UIImageView()
    var itemTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageView)
        addSubview(itemTitleLabel)
        
        configureImageView()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        itemImageView.layer.cornerRadius = 10
        itemImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        itemTitleLabel.numberOfLines = 0
        itemTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 16 / 9).isActive = true
    }
    
    func setTitleLabelConstraints() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemImageView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
