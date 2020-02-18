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
    var cafeComments: CafeComment?
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    let backBtn = UIButton()
    let refreshControl = UIRefreshControl()
    let messageBoardManager = MessageBoardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func initView() {
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.contentInset = UIEdgeInsets(top: height * 0.07, left: 0, bottom: 0, right: 0)
        initBackBtn()
    }
    
    func initBackBtn() {
        backBtn.frame = CGRect(x: width * 0.05, y: height * 0.07, width: width * 0.07, height: width * 0.07)
        backBtn.setImage(UIImage(named: "arrow"), for: .normal)
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backBtn)
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
            cell.setData(data: cafeComments!)
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
        presentVC!.editMessage = cafeComments
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
