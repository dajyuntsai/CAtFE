//
//  PostDetailPhotoCollectionViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/4.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostDetailPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        postImageView.layer.cornerRadius = 15
        cellBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cellBackgroundView.layer.cornerRadius = 15
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cellBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        cellBackgroundView.layer.shadowOpacity = 0.5
        cellBackgroundView.layer.shadowRadius = 2
    }
    
    func setData(data: String) {
        postImageView.loadImage(data)
    }
}
