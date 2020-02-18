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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func editBtn(_ sender: Any) {
        self.delegate?.showEditView(self)
    }
    
    @IBAction func pageControlChange(_ sender: UIPageControl) {
        let currentPageNumber = sender.currentPage
        let width = collectionView.frame.width
        let offset = CGPoint(x: width * CGFloat(currentPageNumber), y: 0)
        collectionView.setContentOffset(offset, animated: true)
    }
    var data: CafeComment?
    
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
                
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
//            data?.postPhotos.count ?? 1
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(named: "MainColor")
        pageControl.hidesForSinglePage = true
    }

    func setData(data: CafeComment) {
        self.data = data
        authorImageView.loadImage(data.userImage)
        authorNameLabel.text = data.userName
        locationLabel.text = data.cafeName
        postContentLabel.text = data.content
        timeAgoLabel.text = data.timeAgo
    }
}

extension PostMessageDetailTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (data?.postPhotos.isEmpty)! {
            return 0
        } else {
            return (data?.postPhotos.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostPhotoCollectionCell",
                                                            for: indexPath) as? PostDetailPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.postImageView.loadImage(data?.postPhotos[indexPath.item])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
