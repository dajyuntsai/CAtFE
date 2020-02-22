//
//  PostMessageReplyTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var replyDateTimeLabel: UILabel!
    @IBOutlet weak var replayContentLabel: UILabel!
    @IBOutlet weak var replayContentView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func initView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        replayContentView.layer.cornerRadius = 15
    }
    
    func setData(data: CafeCommentReplies) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        guard let date = dateFormatter.date(from: data.updatedAt) else { return }
        let timeAgo = date.timeAgoSinceDate()
        userImageView.loadImage(data.user.avatar)
        userNameLabel.text = data.user.name
        replyDateTimeLabel.text = timeAgo
        replayContentLabel.text = data.text
    }
}
