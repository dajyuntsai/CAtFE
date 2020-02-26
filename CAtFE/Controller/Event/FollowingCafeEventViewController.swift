//
//  FollowingCafeEventViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Social
import AVKit
import YPImagePicker

class FollowingCafeEventViewController: BaseViewController {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let refreshControl = UIRefreshControl()
    let selectedImageV = UIImageView()
    var selectedItems = [YPMediaItem]()
    var selectedPhotos: [UIImage] = []
    @IBOutlet weak var createPostBtn: UIButton!
    @IBOutlet weak var createBtnRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    var message: [CafeComments] = [] {
        didSet {
            if message.isEmpty {
                DispatchQueue.main.async {
                    self.refreshControl.beginRefreshing()
                }
            } else {
                DispatchQueue.main.async { // ?????
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    @IBAction func createEventBtn(_ sender: Any) {
        showPicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        getMessageList()
    }
    
    func initView() {
        createPostBtn.layer.cornerRadius = createPostBtn.frame.width / 2
        createBtnBottomConstraint.constant = -height * 0.29
        createBtnRightConstraint.constant = width * 0.05
        
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
        config.showsCrop = .rectangle(ratio: (16/9))
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
            self.showCreatePostView()
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func showCreatePostView() {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageViewController.identifier)
            as? PostMessageViewController
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
    
    @objc func loadData() {
        message.removeAll()
        DispatchQueue.main.async {
            self.getMessageList()
        }
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension FollowingCafeEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowingCafeTableViewCell.identifier,
                                                       for: indexPath) as? FollowingCafeTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
}

extension FollowingCafeEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageDetailViewController.identifier)
            as? PostMessageDetailViewController
//        presentVC?.message = message[indexPath.row]
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
}

extension FollowingCafeEventViewController: GoodCommentShareDelegate {
    func getCommentView(_ cell: FollowingCafeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageDetailViewController.identifier)
            as? PostMessageDetailViewController
//        presentVC?.message = message[indexPath.row]
        presentVC?.modalPresentationStyle = .overFullScreen
        self.show(presentVC!, sender: nil)
    }
    
    func getShareView(_ cell: FollowingCafeTableViewCell) {
        let secondActivityItem: NSURL = NSURL(string: "http://www.google.com")! // TODO: 修改分享網址
        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: [secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getEditView(_ cell: FollowingCafeTableViewCell) {
        let alertController = UIAlertController(title: "選擇功能", message: nil, preferredStyle: .actionSheet)
        let callOutAction = UIAlertAction(title: "編輯", style: .default) { (_) in
//            self.onEditMessage()
        }
        let guideAction = UIAlertAction(title: "刪除", style: .destructive) { (_) in
//            self.onDeleteMessage()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(callOutAction)
        alertController.addAction(guideAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func getMessageList() {
//        let messageBoardManager = MessageBoardManager()
//        messageBoardManager.getMessageList { (result) in
//            switch result {
//            case .success(let cafeData):
//                self.message.removeAll()
//                for messages in cafeData.results {
//                    self.message = messages.cafeComments
//                }
//            case .failure(let error):
//                print("======= 測試資料 error: \(error)")
//            }
//        }
    }
    
    func onEditMessage() {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageViewController.identifier)
            as? PostMessageViewController
        presentVC?.modalPresentationStyle = .formSheet
        presentVC?.loadViewIfNeeded()
        presentVC?.isEditMode = true
        self.present(presentVC!, animated: true, completion: nil)
    }
    
    func onDeleteMessage() { // TODO: delete message api
        self.navigationController?.popToRootViewController(animated: true)
    }
}
