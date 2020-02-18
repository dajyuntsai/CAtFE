//
//  SectionView.swift
//  CAtFE
//
//  Created by Ninn on 2020/2/16.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol SectionViewDelegate: class {
    func sectionView(_ sectionView: SectionView, _ didPressTag: Int, _ isExpand: Bool)
}

class SectionView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    @IBAction func expandBtnClick(_ sender: Any) {
        self.delegate?.sectionView(self, self.buttonTag, self.isExpand)
        expandBtn.isSelected.toggle()
    }
    
    weak var delegate: SectionViewDelegate?
    var buttonTag: Int!
    var isExpand: Bool! // cell 的狀態(展開/縮合)
    
    func setData(data: Settings) {
        titleLabel.text = data.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // ?????
        expandBtn.setImage(UIImage(systemName: "chevron.up"), for: .selected)
        expandBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
}
