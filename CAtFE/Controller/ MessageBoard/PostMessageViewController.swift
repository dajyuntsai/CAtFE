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
        picker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoSelectWay), name: Notification.Name("showPhotoSelectWay"), object: nil)
    }
    
    @objc func showPhotoSelectWay() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "開啟相機拍照", style: .default) { (_) in
            self.onCameraBtnAction()
        }
        let libraryAction = UIAlertAction(title: "從相簿中選擇", style: .default) { (_) in
            self.onPhotoBtnAction()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cameraAction)
        controller.addAction(libraryAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func sendPostBtn(_ sender: Any) {
        if isEditMode {
            onUpdateMessage()
        } else {
            onCreateMessage()
        }
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
                case .success(_):
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
}

extension PostMessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostUserInfoCell", for: indexPath) as? PostMessageUserTableViewCell else {
                return UITableViewCell()
            }
            if isEditMode {
                cell.setData(data: editMessage!)
            } else {
                cell.delegate = self
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentCell", for: indexPath) as? PostMessageContentTableViewCell else {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostPhotoCell", for: indexPath) as? PostMessagePhotoTableViewCell else {
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
        default:
            return UITableViewCell()
        }
    }
}

extension PostMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80
        case 1:
            return 250
        case 2:
            return 180
        default:
            return 80
        }
    }
}

extension PostMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 開啟相機或相簿
    /// - Parameter kind: 1 = 相機, 2 = 相簿
    func callGetPhoneWithKind(_ kind: Int) {
        switch kind {
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = true // 可對照片作編輯
                self.present(picker, animated: true, completion: nil)
            } else {
                alert(message: "沒有相機鏡頭！", title: "慟！")
            }
        default:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                picker.allowsEditing = true // 可對照片作編輯
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    // 相機
    func onCameraBtnAction() {
        self.callGetPhoneWithKind(1)
    }
    
    // 相簿
    func onPhotoBtnAction() {
        self.callGetPhoneWithKind(2)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            selectedPhotoList.append(selectedImageFromPicker!)
        }

        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            let imageData = selectedImage.pngData()
            uploadImage(imageData: imageData!)
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // 圖片picker控制器任務結束回呼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(imageData: Data) {
        // TODO: 上傳到api
        
    }
}

extension PostMessageViewController: TopViewOfCresteMessageDelegate {
    func showSearchView(_ cell: PostMessageUserTableViewCell) {
        let presentVC = UIStoryboard.messageBoard.instantiateViewController(identifier: PostAddLocationViewController.identifier) as? PostAddLocationViewController
        presentVC?.modalPresentationStyle = .formSheet
        presentVC?.delegate = cell
        presentVC?.cafeId = { id in
            self.cafeId = id
        }
        self.present(presentVC!, animated: true, completion: nil)
    }
}

