//
//  CreateDetailOpenTimeTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/9.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol TimePickerDidChangeDelegate: AnyObject {
    
    func textFieldDidChange(textField: UITextField)
}

class CreateDetailOpenTimeTableViewCell: UITableViewCell {
    
    weak var delegate: TimePickerDidChangeDelegate?
    var isRest: (([Bool]) -> Void)?
    var selectedTime: (([String]) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var openTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBAction func restBtn(_ sender: Any) {
        isRest?([true])
    }
    @IBAction func setAllBtn(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        openTimeTextField.delegate = self
        endTimeTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(title: String) {
        titleLabel.text = title
    }
}

extension CreateDetailOpenTimeTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidChange(textField: textField)
        if !textField.isEmpty {
            let inputContent = textField.text!
            selectedTime?([inputContent])
        }
    }
}
