//
//  FollowingCafeEventViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/14.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Social

class FollowingCafeEventViewController: BaseViewController {
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var createPostBtn: UIButton!
    @IBOutlet weak var createBtnRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    var message: [Message] = [] {
        didSet {
            if message.isEmpty {
                refreshControl.beginRefreshing()
            } else {
                DispatchQueue.main.async { // ?????
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    @IBAction func createEventBtn(_ sender: Any) {
        showCreatePostView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        getMessageList()
    }
    
    func initView() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        createPostBtn.layer.cornerRadius = createPostBtn.frame.width / 2
        createBtnBottomConstraint.constant = -height * 0.28
        createBtnRightConstraint.constant = width * 0.05
        
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
        presentVC?.message = message[indexPath.row]
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
    
    func getMessageList() { // 假的
        let messageBoardManager = MessageBoardManager()
        messageBoardManager.getMessageList { (result) in
            switch result {
            case .success(let messageData):
                self.message = messageData.data
            case .failure(let error):
                print("======= 測試資料 error: \(error)")
            }
        }
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
