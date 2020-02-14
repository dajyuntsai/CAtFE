//
//  NoteTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData() {
        noteLabel.text = "備註"
    }
    
}
