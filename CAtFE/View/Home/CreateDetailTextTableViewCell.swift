//
//  CreateDetailTextTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/9.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class CreateDetailTextTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    var userInput: (([String]) -> Void)?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
}

extension CreateDetailTextTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !textField.isEmpty {
            let inputContent = textField.text!
            userInput?([inputContent])
        }
    }
}
