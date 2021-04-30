//
//  ArtistTableViewCell.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

//
//  ListTableViewCell.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit


class ArtistTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let MARGIN: CGFloat = 20
    private let INNER_MARGIN: CGFloat = 4
    private let RIGHT_MARGIN: CGFloat = -50
    var artist: Artist?
    var indexPath: IndexPath!
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 3
        l.textAlignment = .left
        l.text = ""
        l.font = Style.Fonts.name
        l.textColor = Style.Colors.name
        return l
    }()
    
    let descLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .left
        l.text = ""
        l.font = Style.Fonts.description
        l.textColor = Style.Colors.description
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        //
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        //
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MARGIN).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: RIGHT_MARGIN).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MARGIN).isActive = true
        //
        descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MARGIN).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: RIGHT_MARGIN).isActive = true
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: INNER_MARGIN).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MARGIN).isActive = true
        //
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.init(753), for: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

