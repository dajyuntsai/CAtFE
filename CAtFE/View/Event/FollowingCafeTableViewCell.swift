//
//  FollowingCafeTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol GoodCommentShareDelegate: AnyObject {
    func getCommentView(_ cell: FollowingCafeTableViewCell)
    func getShareView(_ cell: FollowingCafeTableViewCell)
}

class FollowingCafeTableViewCell: UITableViewCell {

    weak var delegate: GoodCommentShareDelegate?
    var goodBtnState = false
    let photoList = ["", ""]
    
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBAction func goodBtnClick(_ sender: Any) {
        goodBtnState = !goodBtnState
        let btnImg = goodBtnState == true ?
            UIImage(named: "select_like") : UIImage(named: "unselect_like")
        goodBtn.setImage(btnImg, for: .normal)
    }
    
    @IBAction func commentBtnClick(_ sender: Any) {
        delegate?.getCommentView(self)
    }
    
    @IBAction func shareBtnClick(_ sender: Any) {
        delegate?.getShareView(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        if photoList.count == 0 {
            heightOfCollectionView.constant = 0
        } else {
            heightOfCollectionView.constant = 150
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FollowingCafeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoList.count == 0 {
            return 0
        } else {
            return photoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventPhotoCollectionViewCell.identifier,
                                                            for: indexPath) as? EventPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension FollowingCafeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if photoList.count == 0 {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 150)
        }
    }
}
