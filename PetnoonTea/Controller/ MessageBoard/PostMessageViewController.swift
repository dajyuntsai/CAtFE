//
//  PostMessageViewController.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class PostMessageViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let picker: UIImagePickerController = UIImagePickerController()
    var selectedPhotoList: [UIImage] = []
    
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
        // TODO: 打api, 如果發送成功
        CustomProgressHUD.showSuccess(text: "發送成功")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension PostMessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostUserInfoCell", for: indexPath) as? PostMessageUserTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentCell", for: indexPath) as? PostMessageContentTableViewCell else { return UITableViewCell() }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostPhotoCell", for: indexPath) as? PostMessagePhotoTableViewCell else { return UITableViewCell() }
            cell.photoList = selectedPhotoList
            cell.isReload = true
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
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            print("\(uniqueString), \(selectedImage)")
        }
        
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    // 圖片picker控制器任務結束回呼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PostMessageViewController: SearchCafeDelegate {
    func showSearchView(_ cell: PostMessageUserTableViewCell) {
        let presentVC = UIStoryboard.messageBoard.instantiateViewController(identifier: PostAddLocationViewController.identifier) as? PostAddLocationViewController
        presentVC?.modalPresentationStyle = .overFullScreen
        presentVC?.delegate = cell
        self.present(presentVC!, animated: true, completion: nil)
    }
}
