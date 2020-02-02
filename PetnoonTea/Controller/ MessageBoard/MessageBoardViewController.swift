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

extension MessageBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? MessageCollectionViewCell else { return UICollectionViewCell() }
        cell.post = self.posts?[indexPath.item]
        return cell
    }
}

extension MessageBoardViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let post = posts?[indexPath.item] {
            let topPadding = CGFloat(8)
            let bottomPadding = CGFloat(12)
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: post.caption!, with: captionFont, width: width)
            let height = topPadding + captionHeight + bottomPadding
            
            return height
        }
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let post = posts?[indexPath.item], let photo = post.image {
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect = AVMakeRect(aspectRatio: photo.size, insideRect: boundingRect)
            let profileImageHeight = CGFloat(36)
            
            return profileImageHeight + rect.size.height
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForReplyBtnAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        return 20
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat{
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(64.0)
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}
