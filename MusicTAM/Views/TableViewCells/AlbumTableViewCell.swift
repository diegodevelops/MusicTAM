//
//  ListTableViewCell.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit


class AlbumTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let MARGIN: CGFloat = 20
    private let INNER_MARGIN: CGFloat = 4
    private let RIGHT_MARGIN: CGFloat = -50
    var album: Album?
    var indexPath: IndexPath!
    
    let placeholder: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Style.Colors.imgBackground
        v.layer.cornerRadius = 2
        return v
    }()
    
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = Style.Colors.imgBackground
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 2
        return iv
    }()
    
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
        contentView.addSubview(placeholder)
        contentView.addSubview(imgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        //
        placeholder.heightAnchor.constraint(equalToConstant: 70).isActive = true
        placeholder.widthAnchor.constraint(equalToConstant: 70).isActive = true
        placeholder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MARGIN).isActive = true
        placeholder.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MARGIN).isActive = true
        placeholder.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -MARGIN).isActive = true
        //
        imgView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MARGIN).isActive = true
        imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MARGIN).isActive = true
        imgView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -MARGIN).isActive = true
        //
        nameLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: MARGIN).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: RIGHT_MARGIN).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imgView.topAnchor).isActive = true
        //
        descLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: MARGIN).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: RIGHT_MARGIN).isActive = true
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: INNER_MARGIN).isActive = true
        descLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -MARGIN).isActive = true
        //
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.init(753), for: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func updateImageIfNeeded(image: UIImage?) {
        imgView.image = image
        UIView.animate(withDuration: 0.4, animations: { self.imgView.alpha = 1 })
    }
   
}
