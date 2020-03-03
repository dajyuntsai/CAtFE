//
//  PostMessagePhotoCollectionViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessagePhotoCollectionViewCell: UICollectionViewCell {
            
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBAction func addPhotoBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showAlbum"), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
