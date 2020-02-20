//
//  CreateDetailCheckBoxTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/10.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class CreateDetailCheckBoxTableViewCell: UITableViewCell {

    var petSelected: (([String]) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var catCheckBoxBtn: UIButton!
    @IBOutlet weak var dogCheckBoxBtn: UIButton!
    @IBOutlet weak var otherCheckBoxBtn: UIButton!
    @IBAction func catBtnClick(_ sender: Any) {
        petSelected?(["CAT"])
    }
    @IBAction func dogBtnClick(_ sender: Any) {
        petSelected?(["DOG"])
    }
    @IBAction func otherBtnClick(_ sender: Any) {
        petSelected?(["OTHER"])
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
