//
//  MemberInfoTableViewCell.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/9.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MemberInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPointLabel: UILabel!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
