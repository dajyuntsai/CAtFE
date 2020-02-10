//
//  CreateDetailOpenTimeTableViewCell.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/9.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class CreateDetailOpenTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var openTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBAction func checkBoxBtn(_ sender: Any) {
    }
    @IBAction func setAllBtn(_ sender: Any) {
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
        titleLabel.text = title
    }
}
