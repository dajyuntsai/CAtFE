//
//  CreateDetailStarTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/9.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Cosmos

class CreateDetailStarTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    var starCount: (([Double]) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cosmosView.rating = 0
        cosmosView.settings.fillMode = .full
        cosmosView.didTouchCosmos = { rating in
            self.starCount?([rating])
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(title: String) {
        titleLabel.text = title
    }
}
