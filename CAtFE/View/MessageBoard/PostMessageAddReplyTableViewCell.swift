//
//  PostMessageAddReplyTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/4.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol SendReplyToMessageDelegate: AnyObject {
    func sendReply(_ cell: PostMessageAddReplyTableViewCell, reply: String)
}

class PostMessageAddReplyTableViewCell: UITableViewCell {

    weak var delegate: SendReplyToMessageDelegate?
    var replyMessage: String?
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var replyContentTextField: UITextField!
    @IBAction func sendBtn(_ sender: Any) {
        delegate?.sendReply(self, reply: replyMessage ?? "")
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
        replyContentTextField.delegate = self
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.loadImage(KeyChainManager.shared.avatar)
    }
}

extension PostMessageAddReplyTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !textField.isEmpty {
            replyMessage = textField.text
        }
    }
}
