//
//  PostMessageDetailTableViewCell.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol TopViewOfDetailMessageDelegate: AnyObject {
    func showEditView(_ cell: PostMessageDetailTableViewCell)
}

class PostMessageDetailTableViewCell: UITableViewCell {
    
    weak var delegate: TopViewOfDetailMessageDelegate?
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBAction func editBtn(_ sender: Any) {
        self.delegate?.showEditView(self)
    }
    var data: CafeComments?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
          // Configure the view for the selected state
    }

    func initView() {
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }

    func setData(data: CafeComments) {
        self.data = data
        authorImageView.loadImage(data.user?.avatar)
        authorNameLabel.text = data.user?.name
        locationLabel.text = "data.user"
        postContentLabel.text = data.comment
        timeAgoLabel.text = data.updatedAt
    }
}

//extension PostMessageDetailTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if (data?.photos.isEmpty)! {
//            return 0
//        } else {
//            return (data?.photos.count)!
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostPhotoCollectionCell",
//                                                            for: indexPath) as? PostDetailPhotoCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        cell.postImageView.loadImage(data?.photos[indexPath.item].url)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//        return CGSize(width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height / 3)
//    }
//}
