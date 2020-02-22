//
//  SettingViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import FBSDKLoginKit

struct Settings {
    let type: SectionType
    let title: String
    let details: [String]
}

enum SectionType {
    case expand
    case cell
    case logout
    case createCafe
}

class SettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    let settingList: [Settings] = [
    Settings(type: .expand, title: "個人資料", details: ["頭像", "名稱"]),
    Settings(type: .createCafe, title: "新增店家", details: []),
    Settings(type: .cell, title: "版本", details: []),
    Settings(type: .logout, title: "登出", details: [])]
    let height = UIScreen.main.bounds.height
    let picker: UIImagePickerController = UIImagePickerController()
    var selectedPhoto: UIImage?
    var isExpendDataList: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoSelectWay), name: Notification.Name("showPhotoSelectWay"), object: nil)

        setUptTableView()
        
        for _ in settingList {
            isExpendDataList.append(false)
        }
    }
    
    func setUptTableView() {
        tableView.registerHeaderWithNib(identifier: String(describing: SectionView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: UserInfoTableViewCell.self), bundle: nil)
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
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpendDataList[section] {
            return settingList[section].details.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier,
                                                           for: indexPath) as? UserInfoTableViewCell else {
                                                            return UITableViewCell()
            }
            let data = settingList[indexPath.section].details[indexPath.row]
            if indexPath.row == 0 {
                cell.userNameTextField.isHidden = true
            } else {
                cell.userImageView.isHidden = true
            }
            cell.selectedPhoto = selectedPhoto
            cell.changeUserName = { (name) in
                cell.userNameTextField.text = name
            }
            cell.setData(data: data)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 150
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: String(describing: SectionView.self))
            as? SectionView else {
            return UIView()
        }
        sectionView.setData(data: settingList[section])
        
        switch settingList[section].type {
        case .expand:
            sectionView.isExpand = self.isExpendDataList[section]
            sectionView.buttonTag = section
            sectionView.delegate = self
        case .createCafe:
            let gesture = UITapGestureRecognizer(target: self, action: #selector(createCafe))
            sectionView.addGestureRecognizer(gesture)
            sectionView.expandBtn.isHidden = true
        case .logout:
            let gesture = UITapGestureRecognizer(target: self, action: #selector(logout))
            sectionView.addGestureRecognizer(gesture)
            sectionView.expandBtn.isHidden = true
        default:
            sectionView.expandBtn.isHidden = true
            
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height / 12
    }
    
    @objc func logout() {
        KeyChainManager.shared.token = nil
        KeyChainManager.shared.name = nil
        KeyChainManager.shared.email = nil
        KeyChainManager.shared.avatar = nil
        let presentVC = UIStoryboard.main.instantiateViewController(identifier: LoginViewController.identifier) as? LoginViewController
        presentVC?.modalPresentationStyle = .fullScreen
        self.present(presentVC!, animated: true, completion: nil)
        LoginManager().logOut()
    }
    
    @objc func createCafe() {
        let presentVC = UIStoryboard.createCafe.instantiateViewController(withIdentifier: CreateCafeViewController.identifier) as? CreateCafeViewController
        presentVC?.modalPresentationStyle = .formSheet
        self.present(presentVC!, animated: true, completion: nil)
    }
}

extension SettingViewController: SectionViewDelegate {
    func sectionView(_ sectionView: SectionView, _ didPressTag: Int, _ isExpand: Bool) {
        self.isExpendDataList[didPressTag] = !isExpand
        self.tableView.reloadSections(IndexSet(integer: didPressTag), with: .automatic)
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                alert(message: "沒有相機鏡頭！", title: "慟！", handler: nil)
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
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var selectedImageFromPicker: UIImage?
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            selectedPhoto = selectedImageFromPicker
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
