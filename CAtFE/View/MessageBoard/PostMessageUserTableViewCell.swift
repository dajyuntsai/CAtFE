//
//  PostMessageUserTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol TopViewOfCresteMessageDelegate: AnyObject {
    func showSearchView(_ cell: PostMessageUserTableViewCell)
}

class PostMessageUserTableViewCell: UITableViewCell {

    weak var delegate: TopViewOfCresteMessageDelegate?
    @IBOutlet weak var addLocation: UIButton!
    
    @IBAction func addLocationBtn(_ sender: Any) {
        self.delegate?.showSearchView(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: CafeComments) {
        addLocation.setTitle(data.cafe?.name, for: .normal)
    }
}

extension PostMessageUserTableViewCell: DisplayCafeNameDelegate {
    func setCafeName(cafeName: String) {
        self.addLocation.setTitle(cafeName, for: .normal)
    }
}
