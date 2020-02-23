//
//  UserInfoTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/16.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    var isChangeAvatar = false
    var isChangeName = false
    var newName = ""
    var selectedPhoto: UIImage?
    var changeUserName: ((String) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBAction func cameraBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showPhotoSelectWay"), object: nil)
        isChangeAvatar = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userNameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: String) {
        titleLabel.text = data
        if isChangeName {
            userNameTextField.placeholder = newName
        } else {
            userNameTextField.placeholder = KeyChainManager.shared.name
        }
        
        if isChangeAvatar { // TODO: 更新到後端
            userImageView.image = selectedPhoto
        } else {
            userImageView.loadImage(KeyChainManager.shared.avatar)
        }
    }
}

extension UserInfoTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !textField.isEmpty {
            newName = textField.text!
            changeUserName?(newName)
            isChangeName = true
        }
    }
}
