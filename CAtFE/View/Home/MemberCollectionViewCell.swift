//
//  MemberCollectionViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/11.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: CafeComments) {
        if data.photos.count > 0 {
            imageView.loadImage(data.photos[0].url, placeHolder: UIImage(named: "placeholder"))
        } else {
            imageView.loadImage("https://ppt.cc/f5Rfex@.png")
        }
    }
}
