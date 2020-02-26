//
//  RatedTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Cosmos

protocol RatedCellBtnDelegate: AnyObject {
    func showDetailRadar(_ cell: RatedTableViewCell)
    func getBtnState(_ cell: RatedTableViewCell, _ btnState: Bool)
}

class RatedTableViewCell: UITableViewCell {
    
    weak var delegate: RatedCellBtnDelegate?

    var followBtnState = false
    @IBOutlet weak var backgroungView: UIView!
    @IBOutlet weak var ratedIcon: UIImageView!
    @IBOutlet weak var cafeImageView: UIImageView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeScoreLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var starView: CosmosView!
    @IBAction func followBtnClick(_ sender: Any) {
        followBtnState = !followBtnState
        if followBtnState {
            followBtn.setImage(UIImage(named: "select_bookmark"), for: .normal)
        } else {
            followBtn.setImage(UIImage(named: "unselect_bookmark"), for: .normal)
        }
        delegate?.getBtnState(self, followBtnState)
    }
    
    @IBAction func scoreBtnClick(_ sender: Any) {
        delegate?.showDetailRadar(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cafeImageView.layer.cornerRadius = cafeImageView.frame.width / 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starView.settings.updateOnTouch = false
        starView.settings.fillMode = .precise
        
        followBtn.layer.cornerRadius = 10
        scoreBtn.layer.cornerRadius = 10
        
        backgroungView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backgroungView.layer.shadowColor = UIColor.lightGray.cgColor
        backgroungView.layer.shadowOpacity = 0.5
        backgroungView.layer.shadowRadius = 2
        backgroungView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: Cafe, score: Double) {
//        let stateColor = data == true ? .gray : UIColor(named: "MainColor")
//        followBtn.backgroundColor = stateColor
        cafeNameLabel.text = data.name
        starView.rating = score
        cafeScoreLabel.text = String(round(score*10)/10)
    }
}
