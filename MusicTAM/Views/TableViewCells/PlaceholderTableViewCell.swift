//
//  PlaceholderTableViewCell.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//


import UIKit

protocol PlaceholderTableViewCellDelegate: AnyObject {
    
}

class PlaceholderTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: PlaceholderTableViewCellDelegate?
    private let MARGIN: CGFloat = 20
    private let INNER_MARGIN: CGFloat = 8
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.style = .medium
        return ai
    }()
    
    let txtLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 3
        l.textAlignment = .left
        l.text = ""
        l.font = Style.Fonts.description
        l.textColor = Style.Colors.description
        l.textAlignment = .center
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .none
        //
        contentView.addSubview(activityIndicator)
        contentView.addSubview(txtLabel)
        //
        txtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MARGIN).isActive = true
        txtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -MARGIN).isActive = true
        txtLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MARGIN).isActive = true
        //
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: INNER_MARGIN).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MARGIN).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   
}

