//
//  PostMessageViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let picker: UIImagePickerController = UIImagePickerController()
    let messageBoardManager = MessageBoardManager()
    let height = UIScreen.main.bounds.height
    var selectedPhotoList: [UIImage] = []
    var cafeId: Int?
    var content: String?
    var editMessage: Message?
    var isEditMode = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        initBarBtn()
    }
    
    func initBarBtn() {
        let sendBtn = UIBarButtonItem(title: "發佈",
                                      style: .plain,
                                      target: self,
                                      action: #selector(sendPostBtn))
        self.navigationItem.rightBarButtonItem = sendBtn
    }
    
    func onCreateMessage() {
        guard KeyChainManager.shared.token != nil else {
            return onShowLogin()
        }
        let token = KeyChainManager.shared.token ?? ""
        if content == nil {
            alert(message: "請輸入內容")
        } else {
            messageBoardManager.createMessageInList(token: token,
                                                    cafeID: cafeId ?? 6,
                                                    content: content!,
                                                    photos: []) { (result) in
                switch result {
                case .success:
                    CustomProgressHUD.showSuccess(text: "發送成功")
                    self.navigationController?.popToRootViewController(animated: true)
                case .failure(let error):
                    CustomProgressHUD.showFailure(text: "發送失敗")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        print("======= createMessage error: \(error)")
                    }
                }
            }
        }
    }
    
    func onShowLogin() {
        guard let authVC = UIStoryboard.main.instantiateInitialViewController() else { return }
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)
    }
    
    func onUpdateMessage() { // TODO: update message api
        //        let token = KeyChainManager.shared.token ?? ""
        //        messageBoardManager.updateMessageInList(token: <#T##String#>,
        //                                                messageObj: <#T##Message#>,
        //                                                msgId: <#T##Int#>) { (result) in
        //                                                    switch result {
        //                                                    case .success(_):
        //                                                        <#code#>
        //                                                    case .failure(_):
        //                                                        <#code#>
        //                                                    }
        //        }
    }
    
    @objc func sendPostBtn() {
        if isEditMode {
            onUpdateMessage()
        } else {
            onCreateMessage()
        }
    }
}

extension PostMessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostPhotoCell",
                                                           for: indexPath) as? PostMessagePhotoTableViewCell else {
                return UITableViewCell()
            }
            if isEditMode {
                cell.isEditMode = true
                cell.editPhotoList = editMessage?.photos
                cell.isReload = true
            } else {
                cell.photoList = selectedPhotoList
                cell.isReload = true
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentCell",
                                                           for: indexPath) as? PostMessageContentTableViewCell else {
                return UITableViewCell()
            }
            if isEditMode {
                cell.setData(content: editMessage!.content)
            } else {
                cell.content = { (content) in
                    self.content = content
                }
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostUserInfoCell",
                                                           for: indexPath) as? PostMessageUserTableViewCell else {
                return UITableViewCell()
            }
            if isEditMode {
                cell.setData(data: editMessage!)
            } else {
                cell.delegate = self
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PostMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 180 //height / 4
        case 1:
            return height / 4
        case 2:
            return 70
        default:
            return 80
        }
    }
}

extension PostMessageViewController: TopViewOfCresteMessageDelegate {
    func showSearchView(_ cell: PostMessageUserTableViewCell) {
        let presentVC = UIStoryboard.messageBoard
            .instantiateViewController(identifier: PostAddLocationViewController.identifier)
            as? PostAddLocationViewController
        presentVC?.modalPresentationStyle = .formSheet
        presentVC?.delegate = cell
        presentVC?.cafeId = { id in
            self.cafeId = id
        }
        self.present(presentVC!, animated: true, completion: nil)
    }
}
