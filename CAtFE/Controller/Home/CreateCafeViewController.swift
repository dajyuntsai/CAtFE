//
//  CreateCafeViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

enum CellType {
    case text
    case checkBox
    case bool
    case star
    case openTime
}

struct CellContent {
    var type: CellType
    var title: String
    var value: Any?
}

struct Categorys {
    var title: String
    var cellContent: [CellContent]
}

class CreateCafeViewController: BaseViewController {

    var contents: [CellContent] = [
        CellContent(type: .text, title: "必要資訊"),
        CellContent(type: .text, title: "店名"),
        CellContent(type: .text, title: "店家電話"),
        CellContent(type: .text, title: "店家地址"),
        CellContent(type: .checkBox, title: "寵物類型"),
        CellContent(type: .text, title: "額外資訊"),
        CellContent(type: .text, title: "店家官網或FB粉專"),
        CellContent(type: .bool, title: "有提供 wifi"),
        CellContent(type: .bool, title: "有插座"),
        CellContent(type: .bool, title: "是否限時"),
        CellContent(type: .text, title: "最低消費金額"),
        CellContent(type: .text, title: "營業時間"),
        CellContent(type: .openTime, title: "週一"),
        CellContent(type: .openTime, title: "週二"),
        CellContent(type: .openTime, title: "週三"),
        CellContent(type: .openTime, title: "週四"),
        CellContent(type: .openTime, title: "週五"),
        CellContent(type: .openTime, title: "週六"),
        CellContent(type: .openTime, title: "週日"),
        CellContent(type: .text, title: "為店家評分"),
        CellContent(type: .star, title: "寵物親人"),
        CellContent(type: .star, title: "價格親人"),
        CellContent(type: .star, title: "用餐環境"),
        CellContent(type: .star, title: "餐點好吃"),
        CellContent(type: .star, title: "交通便利"),
        CellContent(type: .text, title: "備註：")
    ]
    
    var categoryList: [Categorys] = [
        Categorys(title: "必要資訊", cellContent:
            [CellContent(type: .text, title: "店名"),
             CellContent(type: .text, title: "店家電話"),
             CellContent(type: .text, title: "店家地址"),
             CellContent(type: .checkBox, title: "寵物類型")]),
        Categorys(title: "額外資訊", cellContent:
            [CellContent(type: .text, title: "店家官網或FB粉專"),
             CellContent(type: .bool, title: "有提供 wifi"),
             CellContent(type: .bool, title: "有插座"),
             CellContent(type: .bool, title: "是否限時"),
             CellContent(type: .text, title: "最低消費金額")]),
        Categorys(title: "營業時間", cellContent:
            [CellContent(type: .openTime, title: "週一"),
             CellContent(type: .openTime, title: "週二"),
             CellContent(type: .openTime, title: "週三"),
             CellContent(type: .openTime, title: "週四"),
             CellContent(type: .openTime, title: "週五"),
             CellContent(type: .openTime, title: "週六"),
             CellContent(type: .openTime, title: "週日")]),
        Categorys(title: "為店家評分", cellContent:
             [CellContent(type: .star, title: "寵物親人"),
              CellContent(type: .star, title: "價格親人"),
              CellContent(type: .star, title: "用餐環境"),
              CellContent(type: .star, title: "餐點好吃"),
              CellContent(type: .star, title: "交通便利"),
              CellContent(type: .text, title: "備註：")])]
    let cafeManager = CafeManager()
    var isExpendDataList: [Bool] = [] {
        didSet {
            for _ in categoryList {
                isExpendDataList.append(false)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBAction func sendCafeBtn(_ sender: Any) {
        sendCafeData()
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }

    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        tableView.registerHeaderWithNib(identifier: String(describing: SectionView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailTextTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailStarTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailBoolTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailCheckBoxTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: CreateDetailOpenTimeTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: ServeyTitleTableViewCell.self), bundle: nil)
    }

    func sendCafeData() {
//        let cafe = Cafe(id: 111,
//                        petType: "test",
//                        name: "test",
//                        tel: "test",
//                        address: "test",
//                        latitude: 25.058734, longitude: 121.548898,
//                        fbUrl: "",
//                        notes: "")
//        cafeManager.createCafeInList(cafeObj: cafe) { (result) in
//            switch result {
//            case .success:
//                CustomProgressHUD.showSuccess(text: "新增成功")
//            case .failure:
//                CustomProgressHUD.showFailure(text: "新增失敗")
//            }
//        }
    }
}

extension CreateCafeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpendDataList[section] {
            return categoryList[section].cellContent.count
        } else {
            return 0
        }
//        return contents[section].title.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1, 2, 3, 6, 10, 25:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailTextTableViewCell.identifier,
                for: indexPath) as? CreateDetailTextTableViewCell else {
                return UITableViewCell()
            }
            cell.userInput = { (text) in
                self.contents[indexPath.row].value = text
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        case 20, 21, 22, 23, 24:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailStarTableViewCell.identifier,
                for: indexPath) as? CreateDetailStarTableViewCell else {
                return UITableViewCell()
            }
            cell.starCount = { (rating) in
                self.contents[indexPath.row].value = rating
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        case 7, 8, 9:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailBoolTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailBoolTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailCheckBoxTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailCheckBoxTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        case 0, 5, 11, 19:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ServeyTitleTableViewCell.identifier,
                                                           for: indexPath) as? ServeyTitleTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailOpenTimeTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailOpenTimeTableViewCell else {
                return UITableViewCell()
            }
            cell.setData(title: contents[indexPath.row].title)
            return cell
        }

    }
}

extension CreateCafeViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 45
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: String(describing: SectionView.self))
            as? SectionView else {
            return UIView()
        }
        
        if section == 0 {
            sectionView.expandBtn.isHidden = true
        }
        
        sectionView.isExpand = self.isExpendDataList[section]
        sectionView.buttonTag = section
        sectionView.delegate = self
        
        sectionView.setServey(data: categoryList[section])
        return sectionView
    }
}

extension CreateCafeViewController: SectionViewDelegate {
    func sectionView(_ sectionView: SectionView, _ didPressTag: Int, _ isExpand: Bool) {
        self.isExpendDataList[didPressTag] = !isExpand
        self.tableView.reloadSections(IndexSet(integer: didPressTag), with: .automatic)
    }
}
