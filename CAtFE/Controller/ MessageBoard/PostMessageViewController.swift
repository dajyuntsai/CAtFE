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
    let width = UIScreen.main.bounds.width
    var selectedPhotoList: [UIImage] = []
    var cafeId: Int?
    var content: String?
    var editMessage: Comments?
    var isEditMode = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func initView() {
        tableView.contentInset = UIEdgeInsets(top: height * 0.07, left: 0, bottom: 0, right: 0)
        initBarBtn()
        initBackBtn()
    }
    
    func initBackBtn() {
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: width * 0.05, y: height * 0.07, width: width * 0.07, height: width * 0.07)
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.setImage(UIImage(named: "arrow"), for: .normal)
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    func initBarBtn() {
        let saveBtn = UIButton()
        saveBtn.frame = CGRect(x: width - (width * 0.05 + width * 0.07), y: height * 0.07, width: width * 0.07, height: width * 0.07)
        saveBtn.setImage(UIImage(named: "send"), for: .normal)
        saveBtn.addTarget(self, action: #selector(sendPostBtn), for: .touchUpInside)
        self.view.addSubview(saveBtn)
    }
    
    func onCreateMessage() {
        guard KeyChainManager.shared.token != nil else {
            return onShowLogin()
        }
        let token = KeyChainManager.shared.token ?? ""
        if content == nil {
            alert(message: "請輸入內容", handler: nil)
        } else {
            messageBoardManager.createMessageInList(token: token,
                                                    cafeID: cafeId ?? 6,
                                                    content: content!,
                                                    photos: ["https://images.pexels.com/photos/104827/cat-pet-animal-domestic-104827.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                                    "https://www.c-ville.com/wp-content/uploads/2019/09/Cats-660x335.jpg",
                                                    "https://s3.amazonaws.com/jo.www.bucket/neighborhoodcats/nodes/images/1844/default/Flynn_Rider_photo.jpg?1548904662"]) { (result) in
                switch result {
                case .success:
                    CustomProgressHUD.showSuccess(text: "發送成功")
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
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
    
    @objc func back() {
        navigationController?.popToRootViewController(animated: true)
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
                cell.editPhotoList = editMessage?.postPhotos
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
            return height / 5
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
