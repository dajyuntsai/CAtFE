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
    @IBOutlet weak var createBtnRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createBtnBottomConstraint: NSLayoutConstraint!
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let messageBoardManager = MessageBoardManager()
    let refreshControl = UIRefreshControl()
    let selectedImageV = UIImageView()
    var selectedItems = [YPMediaItem]()
    var selectedPhotos: [UIImage] = []
    var testPhoto = UIImage()
    
    // from messageboard
    var cafeCommentList: [CafeComments] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getAllMessages), name: Notification.Name("updatePost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPicker), name: Notification.Name("showAlbum"), object: nil)
        
        initView()
        initNavView()
        getAllMessages()
        getLikeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initNavView() {
        let navView = UILabel(frame: CGRect(x: width * 0.1, y: height * 0.06, width: width, height: 50))
        navView.backgroundColor = .white
        navView.text = "留言板"
        navView.font = UIFont(name: "Helvetica Neue", size: 24)
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height * 0.06 + 50))
        bgView.backgroundColor = .white
        self.view.addSubview(bgView)
        self.view.addSubview(navView)
    }

    func initView() {
        createBtnRightConstraint.constant = width * 0.05
        createBtnBottomConstraint.constant = width * 0.05
        addPostBtnView.layer.cornerRadius = addPostBtnView.frame.width / 2

        collectionView?.contentInset = UIEdgeInsets(top: height * 0.06 + 50, left: 8, bottom: 8, right: 8)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc func getAllMessages() {
        let loadingVC = presentLoadingVC()
        messageBoardManager.getMessageList { (result) in
            switch result {
            case .success(let data):
                self.getCommentDetail(data: data)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                CustomProgressHUD.showFailure(text: "讀取資料失敗")
                print("======= getMessageList error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                loadingVC.dismiss(animated: true, completion: nil)
                self.refreshControl.endRefreshing()
            }
        }
    }

    func getCommentDetail(data: [CafeComments]) {
        let sortedComments = data.sorted { $0.updatedAt > $1.updatedAt }
        self.cafeCommentList = sortedComments
    }
    
    func addLikeMessage(_ cell: MessageCollectionViewCell) {
        guard let token = KeyChainManager.shared.token else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let messageId = cafeCommentList[indexPath.row].id
        messageBoardManager.addLikeMessage(token: token, messageId: messageId) { (result) in
            switch result {
            case .success:
                print("收藏成功")
                self.getLikeMessages()
            case .failure(let error):
                CustomProgressHUD.showFailure(text: "\(error.localizedDescription)")
            }
        }
    }
    
    func getLikeMessages() {
        guard let token = KeyChainManager.shared.token else { return }
        messageBoardManager.getLikeMessages(token: token) { (result) in
            switch result {
            case .success(let data):
                MessageBoardObject.shared.likeMessageIdList.removeAll()
                MessageBoardObject.shared.likeMessageIdList = data.data
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("updatePost"), object: nil)
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("======= getLikeMessages() error: \(error)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addPostBtn(_ sender: Any) {
        if KeyChainManager.shared.token != nil {
            showPicker()
        } else {
            alert(message: "登入後才能留言喔！", title: "溫馨小提醒") { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func showPicker() {
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
        config.library.maxNumberOfItems = 1
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
                    self.testPhoto = photo.image
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
            presentVC?.testPhoto = self.testPhoto
            presentVC?.modalPresentationStyle = .overFullScreen
            self.show(presentVC!, sender: nil)
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    @objc func loadData() {
        cafeCommentList.removeAll()
        self.getAllMessages()
    }
}

extension MessageBoardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cafeCommentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? MessageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.likeBtnState = false
        
        for like in MessageBoardObject.shared.likeMessageIdList where like == cafeCommentList[indexPath.item].id {
            cell.likeBtn.isSelected = true
            cell.likeBtnState = true
        }
        
        cell.delegate = self
        cell.setData(message: cafeCommentList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 改成放大圖片
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageDetailViewController.identifier)
            as? PostMessageDetailViewController
        presentVC?.cafeComments = cafeCommentList[indexPath.item]
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
}

extension MessageBoardViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForCaptionAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat {
//        let post = cafeCommentList[indexPath.item]
//        let topPadding = CGFloat(8)
//        let bottomPadding = CGFloat(16)
//        let captionFont = UIFont.systemFont(ofSize: 15)
//        let captionHeight = self.height(for: post.comment, with: captionFont, width: width)
//        let profileImageHeight = CGFloat(36)
//        let height = topPadding + captionHeight + topPadding + profileImageHeight + bottomPadding

        return 50 // height
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForPhotoAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat {
//        let post = cafeCommentList[indexPath.item]
//        let havePhoto = post.photos.count
//
//        if havePhoto == 0 {
//            return 0
//        } else {
//            let photo = URL(string: post.photos[0].url)!
//            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
//            let request = URLRequest(url: photo)
//            guard let imgData = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil) else {
//                return 1.0
//            }
//            var img: UIImage?
//            let imageView1 = UIImageView()
//            img = UIImage(data: imgData)!
//            imageView1.image = img
//            let photoSize = img?.size
//            let rect = AVMakeRect(aspectRatio: photoSize!, insideRect: boundingRect)
//
//            return rect.size.height
//        }
        return 200
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat {
//        let nsstring = NSString(string: text)
//        let textAttributes = [NSAttributedString.Key.font: font]
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingRect = nsstring.boundingRect(with: constraintRect,
//                                                 options: .usesLineFragmentOrigin,
//                                                 attributes: textAttributes, context: nil)
        return 100 // ceil(boundingRect.height)
    }
}

extension MessageBoardViewController: MessageBoardDelegate {
    func showCommentView(_ cell: MessageCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageDetailViewController.identifier)
            as? PostMessageDetailViewController
        presentVC?.cafeComments = cafeCommentList[indexPath.item]
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
    
    func getBtnState(_ cell: MessageCollectionViewCell, _ btnState: Bool) {
        if KeyChainManager.shared.token != nil {
            addLikeMessage(cell)
            self.collectionView.reloadData()
        } else {
            alert(message: "登入後才能收藏喔！", title: "溫馨小提醒") { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
