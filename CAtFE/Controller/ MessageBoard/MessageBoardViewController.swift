//
//  MessageBoardViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/1/30.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MessageBoardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addPostBtnView: UIView!
    let messageBoardManager = MessageBoardManager()
    let refreshControl = UIRefreshControl()
    var messageList: [Message] = [] {
        didSet {
            if messageList.isEmpty {
                refreshControl.beginRefreshing()
            } else {
                DispatchQueue.main.async { // ?????
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        getMessageList()
    }

    func initView() {
        addPostBtnView.layer.cornerRadius = addPostBtnView.frame.width / 2

        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    func getMessageList() {
        messageBoardManager.getMessageList { (result) in
            switch result {
            case .success(let messageData):
                self.messageList = messageData.data
            case .failure(let error):
                print("======= getMessageList error: \(error)")
            }
        }
    }
    
    @IBAction func addPostBtn(_ sender: Any) {
        // TODO: 如果沒有登入就跳到登入頁
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageViewController.identifier)
            as? PostMessageViewController
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }

    @objc func loadData() {
        messageList.removeAll()
        DispatchQueue.main.async {
            self.getMessageList()
        }
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension MessageBoardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell",
                                                            for: indexPath) as? MessageCollectionViewCell else {
                                                                return UICollectionViewCell() }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 15
        cell.setData(message: messageList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageDetailViewController.identifier)
            as? PostMessageDetailViewController
        let message = messageList[indexPath.row]
        presentVC?.message = message
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
}

extension MessageBoardViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForCaptionAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat {
        let post = messageList[indexPath.item]
        let topPadding = CGFloat(8)
        let bottomPadding = CGFloat(16)
        let captionFont = UIFont.systemFont(ofSize: 15)
        let captionHeight = self.height(for: post.content, with: captionFont, width: width)
        let profileImageHeight = CGFloat(36)
        let height = topPadding + captionHeight + topPadding + profileImageHeight + bottomPadding

        return height
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForPhotoAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat {
        let post = messageList[indexPath.item]
        let havePhoto = post.photos.count
        
        if havePhoto == 0 {
            return 30
        } else {
            let photo = URL(string: post.photos[0].url)!
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let request = URLRequest(url: photo)
            guard let imgData = try? NSURLConnection.sendSynchronousRequest(request as URLRequest,
                                                                            returning: nil) else {
                return 0.75
            }
            var img: UIImage?
            let imageView1 = UIImageView()
            img = UIImage(data: imgData)!
            imageView1.image = img
            let photoSize = img?.size
            let rect = AVMakeRect(aspectRatio: photoSize!, insideRect: boundingRect)
            
            return rect.size.height
        }
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat {
        let nsstring = NSString(string: text)
        let textAttributes = [NSAttributedString.Key.font: font]
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingRect = nsstring.boundingRect(with: constraintRect,
                                                 options: .usesLineFragmentOrigin,
                                                 attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}
