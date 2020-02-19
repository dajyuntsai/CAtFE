//
//  servayTitleTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/19.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class ServeyTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
}