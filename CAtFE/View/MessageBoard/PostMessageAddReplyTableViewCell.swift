//
//  PostMessageAddReplyTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/4.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageAddReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var replyContentTextField: UITextField!
    @IBAction func sendBtn(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        
    }

}
