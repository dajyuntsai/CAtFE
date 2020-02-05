//
//  PostMessageUserTableViewCell.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol SearchCafeDelegate: AnyObject {
    
    func showSearchView(_ cell: PostMessageUserTableViewCell)
}

class PostMessageUserTableViewCell: UITableViewCell {

    weak var delegate: SearchCafeDelegate?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addLocation: UIButton!
    @IBAction func addLocationBtn(_ sender: Any) {
        self.delegate?.showSearchView(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PostMessageUserTableViewCell: DisplayCafeNameDelegate {
    func setCafeName(cafeName: String) {
        
        self.addLocation.setTitle(cafeName, for: .normal)
    }
}
