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
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessageList), name: Notification.Name("updatePost"), object: nil)
        getMessageList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        getMessageList()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func messageType(messagesCategory: MessagesCategory) {
        messageType = messagesCategory
    }
    
    @objc func getMessageList() {
        messageList.removeAll()
        likeCountList.removeAll()
        switch self.messageType {
        case .myMessages:
            self.getMyMessages()
        case .likeMessages:
            self.serchLikeMessages()
        }
    }
    
    func getMyMessages() {
        let loadingVC =  presentLoadingVC()
        let userId = KeyChainManager.shared.id
        messageBoardManager.getMyCafeComment(userId: userId) { (result) in
            switch result {
            case .success(let data):
                MessageBoardObject.shared.myMessageIdList.removeAll()
                self.messageList = data
                self.onSortedMessages()
                self.delegate?.getPostCount(postCount: data.count)
                for myMessage in data {
                    MessageBoardObject.shared.myMessageIdList.append(myMessage.id)
                    self.likeCountList.append(myMessage.likeCount)
                }
                self.delegate?.getLikeCount(likeCountList: self.likeCountList)
            case .failure(let error):
                NSLog("getMessages error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    loadingVC.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func serchLikeMessages() {
        let loadingVC =  presentLoadingVC()
        let messageId = MessageBoardObject.shared.likeMessageIdList
        messageBoardManager.getMessageList { (result) in
            switch result {
            case .success(let data):
                for message in data {
                    for id in messageId where message.id == id {
                        self.messageList.append(message)
                    }
                }
                self.onSortedMessages()
            case .failure(let error):
                print("======= getMessageList() error: \(error)")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
                loadingVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func onSortedMessages() {
        let sortedComments = messageList.sorted { $0.updatedAt > $1.updatedAt }
        messageList = sortedComments
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
