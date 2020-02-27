//
//  MyMessagesViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/11.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

enum MessagesCategory {
    case myMessages
    case likeMessages
}

protocol PostCountDelegate: AnyObject {
    func getPostCount(postCount: Int)
    func getLikeCount(likeCountList: [Int])
}

class MyMessagesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: PostCountDelegate?

    private var messageType: MessagesCategory = .myMessages
    let messageBoardManager = MessageBoardManager()
    let cafeManager = CafeManager()
    let refreshControl = UIRefreshControl()
    let width = UIScreen.main.bounds.width
    var likeCountList: [Int] = []
    var messageList: [CafeComments] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMessageList()
    }
    
    func messageType(messagesCategory: MessagesCategory) {
        messageType = messagesCategory
    }
    
    func getMessageList() {
        self.presentLoadingVC()
        messageList.removeAll()
        
        switch self.messageType {
        case .myMessages:
            self.getMyMessages()
        case .likeMessages:
            self.getLikeMessages()
        }
    }
    
    func getMyMessages() {
        let userId = KeyChainManager.shared.id
        messageBoardManager.getMyCafeComment(userId: userId) { (result) in
            switch result {
            case .success(let data):
                self.messageList = data
                self.onSortedMessages()
                self.delegate?.getPostCount(postCount: data.count)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                NSLog("getMessages error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func getLikeMessages() {
        guard let token = KeyChainManager.shared.token else { return }
        messageBoardManager.getLikeMessages(token: token) { (result) in
            switch result {
            case .success(let data):
                self.serchLikeMessages(messageId: data.data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure:
                CustomProgressHUD.showFailure(text: "讀取資料失敗")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func serchLikeMessages(messageId: [Int]) {
        messageBoardManager.getMessageList { (result) in
            switch result {
            case .success(let data):
                for message in data {
                    for id in messageId where message.id == id {
                        self.messageList.append(message)
                    }
                }
            case .failure(let error):
                print("======= getMessageList() error: \(error)")
            }
        }
    }
    
    func onSortedMessages() {
        let sortedComments = messageList.sorted { $0.updatedAt > $1.updatedAt }
        self.messageList = sortedComments
        for like in messageList {
            self.likeCountList.append(like.likeCount)
        }
        self.delegate?.getLikeCount(likeCountList: self.likeCountList)
    }
    
    @objc func loadData() {
        self.messageList.removeAll()
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension MyMessagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.identifier,
                                                            for: indexPath) as? MemberCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(data: messageList[indexPath.row])
        return cell
    }
}

extension MyMessagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (width - 6) / 3, height: (width - 6) / 3)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presentVC = UIStoryboard.messageBoard.instantiateViewController(identifier: PostMessageDetailViewController.identifier) as? PostMessageDetailViewController
        presentVC?.modalPresentationStyle = .overFullScreen
        presentVC?.cafeComments = self.messageList[indexPath.row]
        self.show(presentVC!, sender: nil)
    }
}
