//
//  HomeFilterCollectionViewCell.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/22.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol PetFilterDelegate: AnyObject {
    func showPetCategory(_ cell: HomeFilterCollectionViewCell)
}

class HomeFilterCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PetFilterDelegate?
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBAction func filterButtonClick(_ sender: Any) {
        self.delegate?.showPetCategory(self)
    }
    
    func setData(title: String) {
        filterBtn.setTitle(title, for: .normal)
    }
}
