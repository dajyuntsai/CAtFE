//
//  PostMessagePhotoCollectionViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol DeletePhotoDelegate: AnyObject {
    func removePhoto(_ cell: PostMessagePhotoCollectionViewCell)
}

class PostMessagePhotoCollectionViewCell: UICollectionViewCell {
        
    weak var delegate: DeletePhotoDelegate?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var deletePhotoBtn: UIButton!
    
    @IBAction func addPhotoBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showPhotoSelectWay"), object: nil)
    }
    
    @IBAction func deletePhotoBtn(_ sender: Any) {
        delegate?.removePhoto(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        
    }
}
