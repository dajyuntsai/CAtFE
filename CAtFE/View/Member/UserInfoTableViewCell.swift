//
//  UserInfoTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/16.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: String) {
        userNameTextField.placeholder = KeyChainManager.shared.name
        titleLabel.text = data
        userImageView.image = UIImage(named: "placeholder")
    }
}
