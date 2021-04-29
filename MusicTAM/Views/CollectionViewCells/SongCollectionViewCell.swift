//
//  SongCollectionViewCell.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

class SongCollecionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let MARGIN: CGFloat = 8.0
    private let INNER_MARGIN: CGFloat = 4
    var song: Song?
    
    let tLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.text = ""
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 17)
        return titleLabel
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 2
        //
        addSubview(tLabel)
        addSubview(imgView)
        //
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: frame.width).isActive = true
        //
        tLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: MARGIN).isActive = true
        tLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -MARGIN).isActive = true
        tLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: INNER_MARGIN).isActive = true
        tLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -MARGIN).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateImageIfNeeded(image: UIImage?) {
        imgView.alpha = 0
        imgView.image = image
        UIView.animate(withDuration: 0.4, animations: { self.imgView.alpha = 1 })
    }
}
