//
//  SearchLocationTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/27.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class SearchLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data: [String: String]) {
        titleLabel.text = data["title"]
        descLabel.text = data["address"]
    }
}
