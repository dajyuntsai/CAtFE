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
    func getBtnState(_ cell: RatedTableViewCell)
}

class RatedTableViewCell: UITableViewCell {
    
    weak var delegate: RatedCellBtnDelegate?

    let url = ["https://lh3.googleusercontent.com/proxy/95LFK9GLL9Ek_Sb2g_aryORk6lAf0CFvRUMl7WJpZ9CQ3MvJ3_87g84RhG20okwXdN-4Gz2irOd0i5ii2-N8fpscS4tGvvOs1TvLBE1Q",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSJdZe0n49HkGZNNWSDQT1h4M4N9y7dnBIC5s76ybn0EI2xP9n0",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTSqUn6jTkG8hH7Og-muqdoDHvMyoAFaDU7uMcot37iKgE79e18",
    "https://img1.mashed.com/img/gallery/the-dirty-truth-about-cat-cafes/intro-1524155430.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQEsrwgKFlD5rmOlih4Ux_XJJ1LSDUwlBASr1CpZq6KKIn3UDJb",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSISQkV975uSRFDqe1uq_P27X-EWqao5tciuM_zoI2tbrn4i0L8", "https://www.google.com/imgres?imgurl=https%3A%2F%2Fpausecatcafe.co.uk%2Fwp-content%2Fuploads%2F2019%2F02%2Fimg_1134.jpg&imgrefurl=https%3A%2F%2Fpausecatcafe.co.uk%2Fshop%2Fhigh-tea%2F&tbnid=yRbZt9I1rlNtxM&vet=12ahUKEwia7fCv-v_nAhUTDJQKHabsAagQMygVegQIARAs..i&docid=YPbfZeRD-1OhgM&w=3264&h=2448&q=cat%20afternoon%20tea&client=safari&ved=2ahUKEwia7fCv-v_nAhUTDJQKHabsAagQMygVegQIARAs", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRCBixme7SpsbIAXUAgNAQvkd5QwPhd8whAdfT-HUqArBZZpSzB", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTuuga5ZEaRs0MPS2UEpYs949TfnuOgh6TLLldrJ5FqIhtnozjJ", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQX5TMbtXzDLCXgJ1yo_GKs-nngQ-kXoOB_Re9mLZHnnjZPg992", "https://thenypost.files.wordpress.com/2014/04/invision-amy-sussman_ster.jpg", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRc-pd-emKJX6tBQhJCKWlVnn6vjrCT__23PJpzH0K9W3YjYzji", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQhV21hbRYFVQyn3HWTMXDAZYTM0whfQUx-onWtTli_qObWTWZR", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTF3MgEpGl7gLLx8Cc_FzvjkoCob_0wT5OiBFmiUFq8hiirqCdb", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQc0WTRooyJqICDKVBO1JpkkoaAJS3QffO1y7MyvjoDPytusbgL", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQWOjj-3UG7jux4JdMgySSQ2WC3954PZTxWIB9jI8khUl59d61R", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQl0UM9Xf9babMbiPxNRdpsGCBAlHvPCoIbLTbqKtfRAtzYNEx7", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS29kqu4g4pWeFJJ7hadgyqr3bCshgIx7litev59RccVlE9kh7g", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQp20Kc1mDzQZqCfobNVAtHiqorJAbif4NUW6gDgGO7fFJ6DtAh"]
    
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
        let btnImg = followBtnState == true ? UIImage(named: "select_bookmark") : UIImage(named: "unselect_bookmark")
        followBtn.setImage(btnImg, for: .normal)
        delegate?.getBtnState(self)
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

    }

    func setData(data: Cafe, score: Double) {
        cafeNameLabel.text = data.name
        starView.rating = score
        cafeScoreLabel.text = String(round(score*10)/10)
        
        let btnImg = followBtnState == true ? UIImage(named: "select_bookmark") : UIImage(named: "unselect_bookmark")
        followBtn.setImage(btnImg, for: .normal)
        
        let randomURL = Int.random(in: 0..<url.count)
        cafeImageView.loadImage(url[randomURL])
    }
}
