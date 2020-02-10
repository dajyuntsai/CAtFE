//
//  PostMessageTableViewCell.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
