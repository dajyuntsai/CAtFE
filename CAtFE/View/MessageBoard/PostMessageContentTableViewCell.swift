//
//  PostMessageContentTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cotentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initContentView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initContentView() {
        cotentTextView.layer.borderWidth = 1
        cotentTextView.layer.borderColor = UIColor.gray.cgColor
        cotentTextView.layer.cornerRadius = 10
        
        cotentTextView.text = "輸入留言"
        cotentTextView.textColor = UIColor.lightGray
        cotentTextView.returnKeyType = .done
        
        cotentTextView.delegate = self
    }
}

extension PostMessageContentTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if cotentTextView.text == "輸入留言" {
            cotentTextView.text = ""
            cotentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if cotentTextView.text == "" {
            cotentTextView.text = "輸入留言"
            cotentTextView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let postContent = (cotentTextView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = postContent.count
        return numberOfChars < 300    // 300 Limit Value
    }
}
