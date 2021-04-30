//
//  SongCollectionViewCell.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

protocol SongCollecionViewCellDelegate: AnyObject {
    func tappedPlayButton(cell: SongCollecionViewCell)
}

class SongCollecionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: SongCollecionViewCellDelegate?
    private let MARGIN: CGFloat = 8.0
    private let INNER_MARGIN: CGFloat = 4
    var song: Song?
    
    let tLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.text = ""
        titleLabel.textColor = Style.Colors.name
        titleLabel.font = Style.Fonts.name
        return titleLabel
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = Style.Colors.imgBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let playImgView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        iv.image = UIImage(systemName: "play.circle", withConfiguration: boldConfig)
        iv.tintColor = Style.Colors.button
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 2
        //
        addSubview(tLabel)
        addSubview(imgView)
        addSubview(playImgView)
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
        //
        playImgView.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
        playImgView.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        playImgView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playImgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //
        let tg = UITapGestureRecognizer(target: self, action: #selector(tappedPlayImgView(sender:)))
        playImgView.addGestureRecognizer(tg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateImageIfNeeded(image: UIImage?) {
        imgView.image = image
        UIView.animate(withDuration: 0.4, animations: { self.imgView.alpha = 1 })
    }
    
    @objc private func tappedPlayImgView(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.playImgView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: {
            _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.playImgView.transform = .identity
            }, completion: {
                _ in
                self.delegate?.tappedPlayButton(cell: self)
            })
        })
    }
}
