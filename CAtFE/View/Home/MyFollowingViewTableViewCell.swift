//
//  MyFollowingViewTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/11.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MyFollowingViewTableViewCell: UITableViewCell {

    @IBOutlet weak var cafeImageView: UIImageView!
    @IBOutlet weak var cafeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: Cafe) {
        cafeName.text = data.name
    }
}
