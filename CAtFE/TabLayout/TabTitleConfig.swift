//
//  TabLayout.swift
//  CustomTabLayout
//
//  Created by Ninn on 2020/1/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

public enum TabTitleViewStyle {
    case tabTitleViewStyleDefault       // Default，無背景無底線
    case tabTitleViewStyleCover         // 背景覆蓋
    case tabTitleViewStyleUnderLine     // 底線
}

public enum TabTitleViewScrollStyle {
    case tabTitleViewScrollStyleDefault     // Default，跟随内容滾動
    case tabTitleViewScrollStyleHalf        // 滑到一半改位置
    case tabTitleViewScrollStyleEnded       // 滑動結束改位置
}

// Indicator，只有在TabViewStyleUnderLine才有效
public enum TabIndicatorStyle {
    case tabIndicatorDefault        // Default, equal width to title
    case tabIndicatorFixed          // fix width, align center to title
}

public class TabTitleConfig: NSObject {
    
    public var isNeedBounces: Bool = true
    public var isNeedBottomSeparator: Bool = false
    
    // title space
    public var titleSpacing: CGFloat = 50.0
    // titleView大小
    public var titleViewSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
    
    // title default color
    public var titleColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    // title select color
    public var titleSelectedColor: UIColor = UIColor(named: "MainColor")!
    // title font
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    public var titleViewStyle: TabTitleViewStyle = .tabTitleViewStyleUnderLine
    public var titleViewScrollStyle: TabTitleViewScrollStyle = .tabTitleViewScrollStyleDefault
    
    // Indicator style
    public var indicatorStyle: TabIndicatorStyle = .tabIndicatorFixed
    // Indicator legth, need to setting when fixed
    public var indictorWidth: CGFloat = 0
    
    // Indicator height
    public var underlineHeight: CGFloat = 2.0
    // Indicator color
    public var underlineColor: UIColor = UIColor(named: "MainColor")!
    
    // bg cover
    public var coverColor: UIColor = UIColor.clear
}
