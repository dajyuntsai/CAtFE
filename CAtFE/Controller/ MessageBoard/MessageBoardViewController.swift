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
import YPImagePicker

class MessageBoardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addPostBtnView: UIView!
    let height = UIScreen.main.bounds.height
    let messageBoardManager = MessageBoardManager()
    let refreshControl = UIRefreshControl()
    let selectedImageV = UIImageView()
    var selectedItems = [YPMediaItem]()
    var selectedPhotos: [UIImage] = []
    var cafeResults: [Cafe] = [] {
        didSet {
            if cafeResults.isEmpty {
                DispatchQueue.main.async {
                    self.refreshControl.beginRefreshing()
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    var cafeComments: [CafeComment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        getMessageList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        getMessageList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func initView() {
        addPostBtnView.layer.cornerRadius = addPostBtnView.frame.width / 2

        collectionView?.contentInset = UIEdgeInsets(top: height * 0.05, left: 8, bottom: 8, right: 8)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    func getMessageList() {
        messageBoardManager.getMessageList { (result) in
            switch result {
            case .success(let cafeData):
                self.cafeResults.removeAll()
                self.cafeResults = cafeData.results
                self.getCommentDetail(data: cafeData.results)
            case .failure(let error):
                print("======= getMessageList error: \(error)")
            }
        }
    }
    
    func getCommentDetail(data: [Cafe]) {
        self.cafeComments.removeAll()
        for comments in data {
            for comment in comments.cafeComments {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                guard let date = dateFormatter.date(from: comment.createAt) else { return }
                let timeAgo = date.timeAgoSinceDate()
                let commentInfo = CafeComment(cafeName: comments.name,
                                              userName: "bubu",
                                              userImage: "https://timesofindia.indiatimes.com/thumb/msid-67586673,width-800,height-600,resizemode-4/67586673.jpg",
                                              timeAgo: timeAgo,
                                              postPhotos: ["https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_relaxing_on_patio_other/1800x1200_cat_relaxing_on_patio_other.jpg", "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_weight_other/1800x1200_cat_weight_other.jpg?resize=600px:*"],
                                              content: comment.comment)
                self.cafeComments.append(commentInfo)
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func addPostBtn(_ sender: Any) {
//        if KeyChainManager.shared.token != nil {
//            showPicker()
//        } else {
//            alert(message: "登入後才能留言喔！", title: "溫馨小提醒") { _ in
//                self.backToLoginView()
//            }
//        }
        showPicker()
    }
    
    func showPicker() {
        self.selectedPhotos.removeAll()
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression = AVAssetExportPresetMediumQuality
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 2.0
        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false
        config.library.preselectedItems = selectedItems
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            for item in items {
                switch item {
                case .photo(let photo):
                    self.selectedPhotos.append(photo.image)
                    self.selectedImageV.image = photo.image
                case .video(let video):
                    self.selectedImageV.image = video.thumbnail
                        
                        let assetURL = video.url
                        let playerVC = AVPlayerViewController()
                        let player = AVPlayer(playerItem: AVPlayerItem(url: assetURL))
                        playerVC.player = player
                    
                        picker.dismiss(animated: true, completion: { [weak self] in
                            self?.present(playerVC, animated: true, completion: nil)
                        })
                }
            }
            let presentVC = UIStoryboard.messageBoard
                .instantiateViewController(identifier: PostMessageViewController.identifier)
                as? PostMessageViewController
            presentVC?.selectedPhotoList = self.selectedPhotos
            presentVC?.modalPresentationStyle = .overFullScreen
            self.show(presentVC!, sender: nil)
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    @objc func loadData() {
        cafeResults.removeAll()
        self.getMessageList()
        refreshControl.endRefreshing()
    }
}

extension MessageBoardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cafeComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell",
                                                            for: indexPath) as? MessageCollectionViewCell else {
                                                                return UICollectionViewCell() }
            
        cell.setData(message: cafeComments[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageDetailViewController.identifier)
            as? PostMessageDetailViewController
        presentVC?.cafeComments = cafeComments[indexPath.row]
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
}

extension MessageBoardViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForCaptionAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat {
        let post = cafeComments[indexPath.item]
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
        let post = cafeComments[indexPath.item]
        let havePhoto = post.postPhotos.count
        
        if havePhoto == 0 {
            return 30
        } else {
            let photo = URL(string: post.postPhotos[0])!
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
