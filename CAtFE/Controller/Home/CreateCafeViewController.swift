//
//  CreateCafeViewController.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/6.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

class CreateCafeViewController: BaseViewController {
    
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
        Categorys(title: "店家評分", cellContent:
             [CellContent(type: .star, title: "寵物親人"),
              CellContent(type: .star, title: "價格親人"),
              CellContent(type: .star, title: "用餐環境"),
              CellContent(type: .star, title: "餐點好吃"),
              CellContent(type: .star, title: "交通便利"),
              CellContent(type: .text, title: "備註：")])]
    var isExpendDataList: [Bool] = [true, false, false, false]
    var timePickerText = ""
    let cafeManager = CafeManager()
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

    func showTimePicker() -> UIDatePicker {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(didTimePickerChanged), for: .valueChanged)
        return timePicker
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
        if !categoryList[0].cellContent[0].value.isEmpty &&
        !categoryList[0].cellContent[1].value.isEmpty &&
        !categoryList[0].cellContent[2].value.isEmpty &&
        !categoryList[0].cellContent[3].value.isEmpty {
            alert(message: "資料已送出！", title: "待審核", handler: nil)
        } else {
            alert(message: "請填入必要資訊！", title: "溫馨小提醒", handler: nil)
        }
        print(categoryList)
    }
    
    @objc func didTimePickerChanged(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeStyle = .short
        timePickerText = timeFormatter.string(from: sender.date)
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
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndexPath = categoryList[indexPath.section].cellContent[indexPath.row]
        switch cellIndexPath.type {
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailTextTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailTextTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.section == 0 && indexPath.row == 1 {
                cell.inputTextField.keyboardType = .numberPad
            }
            cell.userInput = { (text) in
                self.categoryList[indexPath.section].cellContent[indexPath.row].value = text
            }
            cell.setData(title: cellIndexPath.title)
            return cell
        case .checkBox:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailCheckBoxTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailCheckBoxTableViewCell else {
                return UITableViewCell()
            }
            cell.petSelected = { petType in
                self.categoryList[indexPath.section].cellContent[indexPath.row].value = petType
            }
            cell.setData(title: cellIndexPath.title)
            return cell
        case .bool:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailBoolTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailBoolTableViewCell else {
                return UITableViewCell()
            }
            // TODO: 只能單選
            cell.boolBtn = { check in
                self.categoryList[indexPath.section].cellContent[indexPath.row].value = check
            }
            cell.setData(title: cellIndexPath.title)
            return cell
        case .star:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailStarTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailStarTableViewCell else {
                return UITableViewCell()
            }
            cell.starCount = { (rating) in
                self.categoryList[indexPath.section].cellContent[indexPath.row].value = rating
            }
            cell.setData(title: cellIndexPath.title)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateDetailOpenTimeTableViewCell.identifier,
                                                           for: indexPath) as? CreateDetailOpenTimeTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.openTimeTextField.inputView = showTimePicker()
            cell.endTimeTextField.inputView = showTimePicker()
            cell.selectedTime = { selectedTime in
                self.categoryList[indexPath.section].cellContent[indexPath.row].value.append(selectedTime)
            }
            cell.isRest = { rest in
                self.categoryList[indexPath.section].cellContent[indexPath.row].value = rest
            }
            cell.setData(title: cellIndexPath.title)
            return cell
        }
    }
}

extension CreateCafeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: String(describing: SectionView.self))
            as? SectionView else {
                return UIView()
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

extension CreateCafeViewController: TimePickerDidChangeDelegate {
    func textFieldDidChange(textField: UITextField) {
        textField.text = timePickerText
    }
}
