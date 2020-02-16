//
//  CreateDetailBoolTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class CreateDetailBoolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sosoBtn: UIButton!
    
    @IBAction func noBtn(_ sender: Any) {
    }
    
    @IBAction func yesBtn(_ sender: Any) {
    }
    
    @IBAction func sosoBtn(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(title: String) {
        descLabel.text = title
    }
}
