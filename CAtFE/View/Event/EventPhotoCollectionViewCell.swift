//
//  EventPhotoCollectionViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/15.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class EventPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventPhotoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 20
    }
}
