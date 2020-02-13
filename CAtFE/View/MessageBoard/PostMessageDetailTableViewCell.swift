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
    var data: Message?
    
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
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = data?.photos.count ?? 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.hidesForSinglePage = true
    }

    func setData(data: Message) {
        self.data = data
        authorImageView.loadImage(data.user.avatar)
        authorNameLabel.text = data.user.name
        timeAgoLabel.text = data.user.createAt
        locationLabel.text = data.cafe.name
        postContentLabel.text = data.content
    }
}

extension PostMessageDetailTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (data?.photos.isEmpty)! {
            return 0
        } else {
            return (data?.photos.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostPhotoCollectionCell", for: indexPath) as? PostDetailPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.postImageView.loadImage(data?.photos[indexPath.item].url)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
