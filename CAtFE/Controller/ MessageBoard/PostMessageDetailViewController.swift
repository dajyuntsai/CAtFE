//
//  PostMessageDetailViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/3.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var message: Message?
    let refreshControl = UIRefreshControl()
    let messageBoardManager = MessageBoardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func loadData() {
        // TODO: calling api for loading reply
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func onShowLogin() {
        guard let authVC = UIStoryboard.main.instantiateInitialViewController() else { return }
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)
    }
}

extension PostMessageDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell",
                                                           for: indexPath) as? PostMessageDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setData(data: message!)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostAddReplyCell",
                                                           for: indexPath) as? PostMessageAddReplyTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell",
                                                           for: indexPath) as? PostMessageReplyTableViewCell else {
            return UITableViewCell() }
            
            cell.replayContentLabel.text = "一個留言"
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
        presentVC!.editMessage = message
        self.present(presentVC!, animated: true, completion: nil)
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
