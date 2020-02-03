//
//  MessageBoardViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MessageBoardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchPosts()
        
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    func fetchPosts() {
        self.posts = Post.fetchPosts()
        self.collectionView?.reloadData()
    }
}

extension MessageBoardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? MessageCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 10
        cell.post = self.posts?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        return
    }
}

extension MessageBoardViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let post = posts?[indexPath.item] {
            let topPadding = CGFloat(8)
            let bottomPadding = CGFloat(16)
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: post.caption!, with: captionFont, width: width)
            let profileImageHeight = CGFloat(36)
            let height = topPadding + captionHeight + topPadding + profileImageHeight + bottomPadding + 50 // btn height + padding
            print(height)
            return height
        }
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let post = posts?[indexPath.item], let photo = post.image {
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect = AVMakeRect(aspectRatio: photo.size, insideRect: boundingRect)
            
            return rect.size.height
        }
        return 0
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat{
        let nsstring = NSString(string: text)
        let textAttributes = [NSAttributedString.Key.font: font]
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingRect = nsstring.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}
