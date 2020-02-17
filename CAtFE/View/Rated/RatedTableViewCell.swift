//
//  RatedTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol RatedCellBtnDelegate: AnyObject {
    func showDetailRadar(_ cell: RatedTableViewCell)
    func getBtnState(_ cell: RatedTableViewCell, _ btnState: Bool)
}

class RatedTableViewCell: UITableViewCell {
    
    weak var delegate: RatedCellBtnDelegate?

    var followBtnState = false
    @IBOutlet weak var ratedIcon: UIImageView!
    @IBOutlet weak var cafeImageView: UIImageView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeScoreLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBAction func followBtnClick(_ sender: Any) {
        if followBtnState {
            followBtn.setTitle("追蹤", for: .normal)
            followBtn.backgroundColor = UIColor(named: "MainColor")
        } else {
            followBtn.setTitle("追蹤中", for: .normal)
            followBtn.backgroundColor = .gray
        }
        followBtnState = !followBtnState
        delegate?.getBtnState(self, followBtnState)
    }
    
    @IBAction func scoreBtnClick(_ sender: Any) {
        delegate?.showDetailRadar(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cafeImageView.layer.cornerRadius = cafeImageView.frame.width / 2
        followBtn.layer.cornerRadius = 10
        scoreBtn.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: Bool) {
        let stateColor = data == true ? .gray : UIColor(named: "MainColor")
        followBtn.backgroundColor = stateColor
    }
}