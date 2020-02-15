//
//  MessageCollectionViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBAction func commentBtn(_ sender: Any) {
    }
    @IBOutlet weak var postImageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            // - change the image height
            postImageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }

    func setData(message: Message) {
        userImageView.loadImage(message.user.avatar)
        userNameLabel.text = message.user.name
        dateTimeLabel.text = message.createAt
        captionLabel.text = message.content
        locationLabel.text = message.cafe.name

        if message.photos.count != 0 {
            postImageView.loadImage(message.photos[0].url)
        }
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true
    }
}
