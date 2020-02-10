//
//  PopupCollectionViewCell.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PopupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
    }

    func setData(title: String, icon: String) {
        iconLabel.text = title
        iconImageView.image = UIImage(named: icon)
    }
}
