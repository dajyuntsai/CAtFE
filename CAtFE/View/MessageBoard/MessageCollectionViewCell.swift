//
//  MessageCollectionViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol MessageBoardDelegate: AnyObject {
    func showCommentView(_ cell: MessageCollectionViewCell)
}
class MessageCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MessageBoardDelegate?
    
    var likeBtnState = false
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBAction func commentBtn(_ sender: Any) {
        delegate?.showCommentView(self)
    }
    @IBAction func likeBtn(_ sender: Any) {
        likeBtnState = !likeBtnState
        let btnImg = likeBtnState == true ?
            UIImage(named: "select_heart") : UIImage(named: "unselect_heart")
        likeBtn.setImage(btnImg, for: .normal)
    }
    @IBOutlet weak var postImageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        cellBackgroundView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        cellBackgroundView.layer.shadowOpacity = 0.5
        cellBackgroundView.layer.shadowRadius = 2
        cellBackgroundView.layer.cornerRadius = 15
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            // - change the image height
            postImageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }

    func setData(message: Comments) {
        userImageView.loadImage(message.userImage)
        userNameLabel.text = message.userName
        dateTimeLabel.text = message.timeAgo
        captionLabel.text = message.content
        locationLabel.text = message.cafeName

        if message.postPhotos.count != 0 {
            postImageView.loadImage(message.postPhotos[0])
        }
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true
    }
}
