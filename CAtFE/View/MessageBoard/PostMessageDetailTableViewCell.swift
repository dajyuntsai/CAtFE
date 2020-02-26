//
//  PostMessageDetailTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol TopViewOfDetailMessageDelegate: AnyObject {
    func showEditView(_ cell: PostMessageDetailTableViewCell)
}

class PostMessageDetailTableViewCell: UITableViewCell {
    
    weak var delegate: TopViewOfDetailMessageDelegate?
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBAction func editBtn(_ sender: Any) {
        self.delegate?.showEditView(self)
    }
    var data: CafeComments?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
          // Configure the view for the selected state
    }

    func initView() {
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }

    func setData(data: CafeComments) {
        self.data = data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        guard let date = dateFormatter.date(from: data.updatedAt) else { return }
        let timeAgo = date.timeAgoSinceDate()
        authorImageView.loadImage(data.user?.avatar)
        authorNameLabel.text = data.user?.name
        locationLabel.text = data.cafe.name
        postContentLabel.text = data.comment
        timeAgoLabel.text = timeAgo
    }
}
