//
//  PostMessageViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/2.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import Alamofire

class PostMessageViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let picker: UIImagePickerController = UIImagePickerController()
    let messageBoardManager = MessageBoardManager()
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    var selectedPhotoList: [UIImage] = [] {
        didSet {
            for photo in selectedPhotoList {
//                postImagesData.append(photo.pngData()!)
            }
        }
    }
    var testPhoto: UIImage? // test
    var cafeId: Int?
    var content: String?
    var editMessage: CafeComments?
    var postImagesData: Data? //[Data] = []
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
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.backgroundColor = .lightGray
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
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
    
    func onUploadPostData() {
        guard let token = KeyChainManager.shared.token else { return }
        let url = URL(string: "https://catfe.herokuapp.com/cafes/\(cafeId ?? 6)/comment/")!
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": "Bearer \(token)"
        ]
        AF.upload(multipartFormData: { (multipartFormData) in
//            for photo in self.postImagesData {
            let test = self.testPhoto?.pngData()
            multipartFormData.append(test!, withName: "photos[]", fileName: "photos.jpg", mimeType: "image/jpeg")
//            }
            multipartFormData.append(self.content!.data(using: String.Encoding.utf8)!, withName: "comment")
        }, to: url,
           method: .post,
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
                }
                self.dismiss(animated: true, completion: nil)
                CustomProgressHUD.showSuccess(text: "發送成功")
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                NSLog("error: \(error.localizedDescription)")
                self.dismiss(animated: true, completion: nil)
                CustomProgressHUD.showFailure(text: "發送失敗")
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func onUpdateMessage() {
        // TODO: update message feature
    }
    
    func onShowLogin() {
        guard let authVC = UIStoryboard.main.instantiateInitialViewController() else { return }
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)
    }
    
    @objc func sendPostBtn() {
        if isEditMode {
            onUpdateMessage()
        } else {
            if content == nil {
                alert(message: "請輸入內容再送出", title: "溫馨小提醒", handler: nil)
            } else {
                presentLoadingVC()
                self.onUploadPostData()
            }
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
//                cell.editPhotoList = editMessage?.postPhotos
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
//                cell.setData(content: editMessage!.content)
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
