//
//  PostMessagePhotoCollectionViewCell.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessagePhotoCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBAction func addPhotoBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showAlertSheet"), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    func initView() {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
    }
}
