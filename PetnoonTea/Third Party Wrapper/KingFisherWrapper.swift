//
//  KingFisherWrapper.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/22.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        guard urlString != nil else { return }
        let url = URL(string: urlString!)
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
