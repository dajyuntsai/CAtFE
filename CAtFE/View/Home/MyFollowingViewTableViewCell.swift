//
//  MyFollowingViewTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/11.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MyFollowingViewTableViewCell: UITableViewCell {

    @IBOutlet weak var cafeImageView: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    
    let url = ["https://lh3.googleusercontent.com/proxy/95LFK9GLL9Ek_Sb2g_aryORk6lAf0CFvRUMl7WJpZ9CQ3MvJ3_87g84RhG20okwXdN-4Gz2irOd0i5ii2-N8fpscS4tGvvOs1TvLBE1Q",
               "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSJdZe0n49HkGZNNWSDQT1h4M4N9y7dnBIC5s76ybn0EI2xP9n0",
               "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTSqUn6jTkG8hH7Og-muqdoDHvMyoAFaDU7uMcot37iKgE79e18",
               "https://img1.mashed.com/img/gallery/the-dirty-truth-about-cat-cafes/intro-1524155430.jpg",
               "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQEsrwgKFlD5rmOlih4Ux_XJJ1LSDUwlBASr1CpZq6KKIn3UDJb",
               "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSISQkV975uSRFDqe1uq_P27X-EWqao5tciuM_zoI2tbrn4i0L8"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        cafeImageView.layer.cornerRadius = cafeImageView.frame.width / 2
    }

    func setData(data: Cafe) {
        let randomURL = Int.random(in: 0..<url.count)
        cafeName.text = data.name
        cafeImageView.loadImage(url[randomURL])
    }
}
