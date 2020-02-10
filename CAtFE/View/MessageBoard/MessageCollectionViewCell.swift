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
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    func updateUI(){
        userImageView.image = UIImage(named: "home")
        userImageView.layer.cornerRadius = 3.0
        userImageView.layer.masksToBounds = true
        
        userNameLabel.text = post.createdBy.username
        dateTimeLabel.text = post.timeAgo
        captionLabel.text = post.caption
        
        postImageView.image = post.image
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes){
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            // - change the image height
            postImageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
