//
//  PlayableItemCell.swift
//  MiniSounds
//
//  Created by Daniel Barclay on 03/03/2020.
//  Copyright © 2020 Daniel Barclay. All rights reserved.
//

import Kingfisher
import UIKit

class PlayableItemCell: UITableViewCell {
    var itemImageView = UIImageView()
    var itemTitleLabel = UILabel()
    var itemsSubtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageView)
        addSubview(itemTitleLabel)
        addSubview(itemsSubtitleLabel)
        
        configureImageView()
        configureTitleLabel()
        configureSubtitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
        setSubtitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(playableViewModel: PlayableViewModel) {
        itemImageView.kf.setImage(with: playableViewModel.iChefUrl, placeholder: playableViewModel.placeholderImage)
        itemTitleLabel.text = playableViewModel.playable.titles.primary
        itemTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        itemsSubtitleLabel.text = playableViewModel.playable.network.short_title
        itemsSubtitleLabel.textColor = UIColor.soundsOrange
    }
    
    func configureImageView() {
        itemImageView.layer.cornerRadius = 10
        itemImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        itemTitleLabel.numberOfLines = 0
        itemTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureSubtitleLabel() {
        itemsSubtitleLabel.numberOfLines = 0
        itemsSubtitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 16 / 9).isActive = true
    }
    
    func setTitleLabelConstraints() {
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        itemTitleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20).isActive = true
        itemTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        itemTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    func setSubtitleLabelConstraints() {
        itemsSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsSubtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15).isActive = true
        itemsSubtitleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20).isActive = true
        itemsSubtitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        itemsSubtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
