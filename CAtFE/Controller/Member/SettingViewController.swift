//
//  SettingViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

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
//    Settings(type: .createCafe, title: "新增店家", details: []),
    Settings(type: .cell, title: "版本  1.4.0", details: []),
    Settings(type: .logout, title: "登出", details: [])]
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    let userProvider = UserProvider()
    let picker: UIImagePickerController = UIImagePickerController()
    var selectedPhoto: UIImage?
    var updateName = ""
    var updateAvatar: Data?
    var isExpendDataList: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoSelectWay), name: Notification.Name("showPhotoSelectWay"), object: nil)

        initView()
        
        for _ in settingList {
            isExpendDataList.append(false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func initView() {
        initBackBtn()
        initSendBtn()
        setUptTableView()
    }
    
    func initBackBtn() {
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: width * 0.05, y: height * 0.07, width: width * 0.1, height: width * 0.1)
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.backgroundColor = .lightGray
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    func initSendBtn() {
        let saveBtn = UIButton()
        saveBtn.frame = CGRect(x: width - (width * 0.05 + width * 0.1), y: height * 0.07, width: width * 0.1, height: width * 0.1)
        saveBtn.setImage(UIImage(named: "send"), for: .normal)
        saveBtn.addTarget(self, action: #selector(updateUserInfo), for: .touchUpInside)
        self.view.addSubview(saveBtn)
    }
    
    func setUptTableView() {
        tableView.contentInset = UIEdgeInsets(top: height * 0.1, left: 0, bottom: 0, right: 0)
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
    
    @objc func updateUserInfo() {
        guard let token = KeyChainManager.shared.token else { return }
        let url = URL(string: "https://catfe.herokuapp.com/users/me/")!
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": "Bearer \(token)"
        ]
        
        if !self.updateName.isEmpty {
            self.uploadUserName(url: url, headers: headers)
        }
        
        if self.selectedPhoto != nil {
            self.uploadUserImage(url: url, headers: headers)
        }
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadUserName(url: URL, headers: HTTPHeaders) {
        let loadingVC = presentLoadingVC()
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(self.updateName.data(using: String.Encoding.utf8)!, withName: "name")
        }, to: url,
           method: .patch,
           headers: headers).response { (response) in
            if let statusCode = response.response?.statusCode {
                NSLog("statusCode: \(statusCode)")
            }
            switch response.result {
            case .success(let data):
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) ,
                    let jsonDict = json as? [String: Any] {
                    NSLog("jsonDict : \(jsonDict)")
                    guard let user = jsonDict["user"] as? [String: Any] else { return }
                    guard let name = user["name"] as? String else { return }
                    KeyChainManager.shared.name = "\(name)"
                }
                CustomProgressHUD.showSuccess(text: "更改成功")
            case .failure(let error):
                NSLog("error: \(error.localizedDescription)")
                CustomProgressHUD.showFailure(text: "更改失敗")
            }
            DispatchQueue.main.async {
                loadingVC.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func uploadUserImage(url: URL, headers: HTTPHeaders) {
        let loadingVC = presentLoadingVC()
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(self.updateAvatar!, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
        }, to: url,
           method: .patch,
           headers: headers).response { (response) in
            if let statusCode = response.response?.statusCode {
                NSLog("statusCode: \(statusCode)")
            }
            switch response.result {
            case .success(let data):
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) ,
                    let jsonDict = json as? [String: Any] {
                    NSLog("jsonDict : \(jsonDict)")
                    guard let user = jsonDict["user"] as? [String: Any] else { return }
                    guard let avatar = user["avatar"] as? String else { return }
                    KeyChainManager.shared.avatar = avatar
                }
                CustomProgressHUD.showSuccess(text: "更改成功")
            case .failure(let error):
                NSLog("error: \(error.localizedDescription)")
                CustomProgressHUD.showFailure(text: "更改失敗")
            }
            DispatchQueue.main.async {
                loadingVC.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
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
                self.updateName = name
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
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            let imageData = selectedImage.jpegData(compressionQuality: 0.6)
//            let strBase64 = imageData?.base64EncodedData(options: .lineLength64Characters)
//            let img = "data:image/png;base64,\(strBase64)"
            updateAvatar = imageData
        }
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    // 圖片picker控制器任務結束回呼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
