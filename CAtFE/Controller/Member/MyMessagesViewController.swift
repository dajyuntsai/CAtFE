//
//  MyMessagesViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/11.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class MyMessagesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let messageBoardManager = MessageBoardManager()
    let refreshControl = UIRefreshControl()
    let width = UIScreen.main.bounds.width
    var myMessages: [CafeComments] = [] {
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
        
        getMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentLoadingVC()
        getMessages()
    }
    
    func getMessages() {
        let userId = KeyChainManager.shared.id
        messageBoardManager.getMyCafeComment(userId: userId) { (result) in
            switch result {
             case .success(let data):
                self.myMessages = data.results
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                NSLog("getMessages error: \(error.localizedDescription)")
            }
        }
    }

    @objc func loadData() {
        self.myMessages.removeAll()
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension MyMessagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myMessages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.identifier,
                                                            for: indexPath) as? MemberCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(data: myMessages[indexPath.row])
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
        presentVC?.cafeComments = self.myMessages[indexPath.row]
        self.show(presentVC!, sender: nil)
    }
}
