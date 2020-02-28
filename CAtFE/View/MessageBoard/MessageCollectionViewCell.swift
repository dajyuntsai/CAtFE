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
    func getBtnState(_ cell: MessageCollectionViewCell, _ btnState: Bool)
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
            UIImage(named: "heart_fill") : UIImage(named: "favourite")
        likeBtn.setImage(btnImg, for: .normal)
        delegate?.getBtnState(self, likeBtnState)
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
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
//            // - change the image height
//            postImageViewHeightLayoutConstraint.constant = attributes.photoHeight
//        }
//    }

    func setData(message: CafeComments) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        guard let date = dateFormatter.date(from: message.updatedAt) else { return }
        let timeAgo = date.timeAgoSinceDate()
        if message.user?.avatar != nil {
            userImageView.loadImage(message.user?.avatar, placeHolder: UIImage(named: "placeholder"))
        } else {
            userImageView.image = UIImage(named: "placeholder")
        }
        userNameLabel.text = message.user?.name
        dateTimeLabel.text = timeAgo
        captionLabel.text = message.comment
        locationLabel.text = message.cafe.name

        if message.photos.count != 0 {
            postImageView.loadImage(message.photos[0].url, placeHolder: UIImage(named: "placeholder"))
        } 
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true
        
        let heartState = likeBtnState == true ? "heart_fill" : "favourite"
        likeBtn.setImage(UIImage(named: heartState), for: .normal)
    }
}
