//
//  PostMessageDetailViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    // from my messages
    var cafeComments: CafeComments?
    var location: String?
    
//    var cafeComments: [CafeComments] = []
    var messageId: Int?
    var headerView = UIView()
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    let backBtn = UIButton()
    let refreshControl = UIRefreshControl()
    let pageControl = UIPageControl()
    let messageBoardManager = MessageBoardManager()
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
                                                            width: UIScreen.main.bounds.width,
                                                            height: UIScreen.main.bounds.height / 3),
                                              collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initView() {
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        initBackBtn()
        initHeader()
//        getMessageDetail()
    }
    
    func initBackBtn() {
        backBtn.frame = CGRect(x: width * 0.05, y: height * 0.07, width: width * 0.07, height: width * 0.07)
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.backgroundColor = .lightGray
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    func initHeader() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height / 3))
        tableView.tableHeaderView = headerView
        headerView.addSubview(collectionView)
        headerView.addSubview(pageControl)
        
        setUpCollectionView()
        setUpPageControl()
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.registerCellWithNib(identifier: String(describing: PostDetailPhotoCollectionViewCell.self), bundle: nil)
    }
    
    func setUpPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = cafeComments?.photos.count ?? 1
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(named: "MainColor")
        pageControl.hidesForSinglePage = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
    }

    @objc func loadData() {
        // TODO: calling api for loading reply
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func back() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func onShowLogin() {
        guard let authVC = UIStoryboard.main.instantiateInitialViewController() else { return }
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y > -1 {
            backBtn.isHidden = false
        } else {
            backBtn.isHidden = true
        }
    }
    
    func sendReplyMessage(text: String) {
        guard KeyChainManager.shared.token != nil else {
            alert(message: "請先登入後再留言") { _ in
                self.onShowLogin()
            }
            return
        }
        guard let token = KeyChainManager.shared.token else { return }
        messageId = cafeComments?.id
        messageBoardManager.replyMessage(
            token: token,
            messageId: messageId!,
            text: text) { (reuslt) in
                switch reuslt {
                case .success(let data):
//                    self.cafeComments = data
                    CustomProgressHUD.showSuccess(text: "發送成功")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure:
                    CustomProgressHUD.showFailure(text: "發送失敗")
                }
        }
    }
    
//    func getMessageDetail() {
//        let userId = KeyChainManager.shared.id
//        messageBoardManager.getMyCafeComment(userId: userId, completion: { (result) in
//            switch result {
//            case .success(let data):
//                self.cafeComments = data.results
//                self.initHeader()
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print("======= getMessageDetail() error: \(error.localizedDescription)")
//            }
//        })
//    }
}

extension PostMessageDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cafeComments?.cafeCommentReplies.count == 0 {
            return 2
        } else {
            return cafeComments!.cafeCommentReplies.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell",
                                                           for: indexPath) as? PostMessageDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setData(data: cafeComments!)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostAddReplyCell",
                                                           for: indexPath) as? PostMessageAddReplyTableViewCell else {
                return UITableViewCell()
            }
            cell.replyContentTextField.text = ""
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell",
                                                           for: indexPath) as? PostMessageReplyTableViewCell else {
            return UITableViewCell() }
            
            cell.setData(data: cafeComments!.cafeCommentReplies[indexPath.row - 2])
            return cell
        }
    }
}

extension PostMessageDetailViewController: UITableViewDelegate {

}

extension PostMessageDetailViewController: TopViewOfDetailMessageDelegate {
    func showEditView(_ cell: PostMessageDetailTableViewCell) {
        let alertController = UIAlertController(title: "選擇功能", message: nil, preferredStyle: .actionSheet)
        let callOutAction = UIAlertAction(title: "編輯", style: .default) { (_) in
            self.onEditMessage()
        }
        let guideAction = UIAlertAction(title: "刪除", style: .destructive) { (_) in
            self.onDeleteMessage()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(callOutAction)
        alertController.addAction(guideAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func onEditMessage() {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostMessageViewController.identifier)
            as? PostMessageViewController
        presentVC?.modalPresentationStyle = .formSheet
        presentVC?.loadViewIfNeeded()
        presentVC?.isEditMode = true
//        presentVC!.editMessage = cafeComments
        self.show(presentVC!, sender: nil)
    }
    
    func onDeleteMessage() { // TODO: delete message api
//        messageBoardManager.deleteMessageInList(token: <#T##String#>, messageObj: <#T##Message#>, msgId: <#T##Int#>) { (result) in
//            switch result {
//            case .success:
//                CustomProgressHUD.showSuccess(text: "刪除成功")
//            case .failure:
//                CustomProgressHUD.showFailure(text: "刪除失敗")
//            }
//        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension PostMessageDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cafeComments!.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostDetailPhotoCollectionViewCell.identifier,
                                                            for: indexPath) as? PostDetailPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(data: (cafeComments!.photos[indexPath.item].url))
        return cell
    }
}

extension PostMessageDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension PostMessageDetailViewController: SendReplyToMessageDelegate {
    func sendReply(_ cell: PostMessageAddReplyTableViewCell, reply: String) {
        if reply == "" {
            alert(message: "請輸入內容再送出", title: "溫馨小提醒", handler: nil)
        } else {
            self.sendReplyMessage(text: reply)
        }
    }
}
