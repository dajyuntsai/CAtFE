//
//  TabTitleView.swift
//  CustomTabLayout
//
//  Created by Ninn on 2020/1/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

public protocol TabTitleViewDelegate: NSObjectProtocol {
    // when click title, scroll contentView
    func selectPageTitleView(_ pageTitleView: TabTitleView, withIndex index: Int)
}

public class TabTitleView: UIView {

    // current index
    private var mSelectedIndex: Int
    // current btn
    private var mSelectedBtn: UIButton?
    
    private let mTitleConfig: TabTitleConfig
    private let mTitleViewDelegate: TabTitleViewDelegate
    
    // title array
    private let mTitleArr: [String]
    // width of all btn
    private var mBtnWidthArr = [CGFloat]()
    // all btn
    private var mBtnArr = [UIButton]()
    
    // indicator
    private var mIndicatorView: UIView?
    private var mScrollView: UIScrollView!
    // total width of scrollview
    private var mContentWidth: CGFloat = 0.0
    
    public init(frame: CGRect, titleArr: [String], config: TabTitleConfig, delegate: TabTitleViewDelegate, selectedIndex: Int = 0) {
        mTitleArr = titleArr
        mTitleConfig = config
        mTitleViewDelegate = delegate
        if selectedIndex >= titleArr.count
        || selectedIndex < 0 {
            mSelectedIndex = 0
        } else {
            mSelectedIndex = selectedIndex
        }
        
        super.init(frame: frame)
        initTitleView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initTitleView() {
        if mTitleConfig.isNeedBottomSeparator {
            initBottomSeparator()
        }
        initScrollView()
        initTitles()
        switch mTitleConfig.titleViewStyle {
        case .tabTitleViewStyleDefault:
            break
        case .tabTitleViewStyleUnderLine:
            initUnderLine()
        case .tabTitleViewStyleCover:
            initCover()
        }
    }
    
    private func initBottomSeparator() {
        let bottom = UIView(frame: CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        self.addSubview(bottom)
        bottom.backgroundColor = UIColor.lightGray
    }
    
    private func initScrollView() {
        mScrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        mScrollView.showsVerticalScrollIndicator = false
        mScrollView.showsHorizontalScrollIndicator = false
        mScrollView.alwaysBounceHorizontal = true
        if !mTitleConfig.isNeedBounces {
            mScrollView.bounces = false
        }
        addSubview(mScrollView)
    }
    
    private func initTitles() {
        for title in mTitleArr {
            let width = widthWithString(title, font: mTitleConfig.titleFont) + mTitleConfig.titleSpacing
            mBtnWidthArr.append(width)
            mContentWidth += width
        }
        
        var tempX: CGFloat = 0
        var btnH = mScrollView.frame.size.height
        if mTitleConfig.titleViewStyle == .tabTitleViewStyleUnderLine {
            btnH -= mTitleConfig.underlineHeight
        }
        if mContentWidth < mScrollView.frame.size.width {
            mScrollView.contentSize = mScrollView.frame.size
            mContentWidth = mScrollView.frame.size.width
            
            let tempW = mContentWidth / CGFloat(mTitleArr.count)
            for (index, value) in mTitleArr.enumerated() { // ?
                mScrollView.addSubview(createBtn(frame: CGRect(x: tempX, y: 0, width: tempW, height: btnH), index: index, value: value))
                tempX += tempW
            }
        } else {
            mScrollView.contentSize = CGSize(width: mContentWidth, height: mScrollView.frame.size.height)
            
            for (index, value) in mTitleArr.enumerated() {
                mScrollView.addSubview(createBtn(frame: CGRect(x: tempX, y: 0, width: mBtnWidthArr[index], height: btnH), index: index, value: value))
                tempX += mBtnWidthArr[index]
            }
        }
    }
    
    private func initUnderLine() {
        var width: CGFloat = mBtnArr[0].frame.size.width
        if mTitleConfig.indicatorStyle == .tabIndicatorFixed {
            if mTitleConfig.indictorWidth <= 0 {
                mTitleConfig.indicatorStyle = .tabIndicatorDefault
            } else {
                width = mTitleConfig.indictorWidth
            }
        }
        mIndicatorView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - mTitleConfig.underlineHeight, width: width, height: mTitleConfig.underlineHeight))
        mScrollView.insertSubview(mIndicatorView!, at: 0)
        mIndicatorView?.center = CGPoint(x: mBtnArr[0].center.x, y: mIndicatorView!.center.y)
        mIndicatorView?.backgroundColor = mTitleConfig.underlineColor
    }
    
    private func initCover() {
        if mTitleConfig.indicatorStyle == .tabIndicatorFixed {
            mTitleConfig.indicatorStyle = .tabIndicatorDefault
        }
        let btnF = mBtnArr[0].frame
        mIndicatorView = UIView(frame: CGRect(origin: btnF.origin, size: btnF.size))
        mScrollView.insertSubview(mIndicatorView!, at: 0)
        mIndicatorView?.backgroundColor = mTitleConfig.coverColor
    }

    // MARK: - state of btn
    private func changeSelectedBtn(_ sender: UIButton) {
        if mSelectedBtn != sender {
            mSelectedBtn?.setTitleColor(mTitleConfig.titleColor, for: .normal)
            sender.setTitleColor(mTitleConfig.titleSelectedColor, for: .normal)
            
            mSelectedBtn = sender
            mSelectedIndex = sender.tag
        }
    }
    
    // MARK: - btn scrool to center
    private func scrollBtnToCenter(sender: UIButton) {
        if mContentWidth <= self.frame.size.width {
            return
        }
        
        var offsetX = sender.center.x - self.frame.size.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        
        let maxOffset = mContentWidth - self.frame.size.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        mScrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
    
    // MARK: - indicator scrool handler
    private func setIndicatorViewTransformWithTargetBtn(_ targetBtn: UIButton) {
        weak var weakSelf = self
        if weakSelf?.mTitleConfig.indicatorStyle == .tabIndicatorFixed {
            UIView.animate(withDuration: 0.2) {
                weakSelf?.mIndicatorView?.center.x = targetBtn.center.x
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                weakSelf?.mIndicatorView?.frame.origin.x = targetBtn.frame.origin.x
                weakSelf?.mIndicatorView?.frame.size.width = targetBtn.frame.size.width
            }
        }
    }
    
    private func setIndicatorViewTransformWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        switch mTitleConfig.titleViewScrollStyle {
        case .tabTitleViewScrollStyleDefault:
            indicatorTransDefaultWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        case .tabTitleViewScrollStyleHalf:
            indicatorTransHalfWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        case .tabTitleViewScrollStyleEnded:
            indicatorTransEndedWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        }
    }
    
    private func indicatorTransDefaultWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        switch mTitleConfig.indicatorStyle {
        case .tabIndicatorDefault:
            let totalOffset = targetBtn.center.x - originalBtn.center.x
            let diff = targetBtn.frame.size.width - originalBtn.frame.size.width
            mIndicatorView?.center.x = originalBtn.center.x + totalOffset * progress
            mIndicatorView?.frame.size.width = originalBtn.frame.size.width + diff * progress
        case .tabIndicatorFixed:
            let totalOffset = targetBtn.center.x - originalBtn.center.x
            mIndicatorView?.center.x = originalBtn.center.x + totalOffset * progress
        }
    }
    
    private func indicatorTransHalfWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        weak var weakSelf = self
        switch mTitleConfig.indicatorStyle {
        case .tabIndicatorDefault:
            if progress >= 0.5 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = targetBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = targetBtn.frame.size.width
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = originalBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = originalBtn.frame.size.width
                })
            }
        case .tabIndicatorFixed:
            if progress >= 0.5 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = targetBtn.center.x
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = originalBtn.center.x
                })
            }
        }
    }
    
    private func indicatorTransEndedWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        weak var weakSelf = self
        switch mTitleConfig.indicatorStyle {
        case .tabIndicatorDefault:
            if progress == 1.0 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = targetBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = targetBtn.frame.size.width
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = originalBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = originalBtn.frame.size.width
                })
            }
        case .tabIndicatorFixed:
            if progress == 1.0 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = targetBtn.center.x
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = originalBtn.center.x
                })
            }
        }
    }
    
    // MARK: - create title
    private func createBtn(frame: CGRect, index: Int, value: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = frame
        mBtnArr.append(btn)
        btn.tag = index
        btn.setTitle(value, for: .normal)
        btn.setTitleColor(mTitleConfig.titleColor, for: .normal)
        btn.titleLabel?.font = mTitleConfig.titleFont
        btn.addTarget(self, action: #selector(onBtnClicked(_:)), for: .touchUpInside)
        
        if mSelectedIndex == index {
            mSelectedBtn = btn
            btn.setTitleColor(mTitleConfig.titleSelectedColor, for: .normal)
        }
        return btn
    }
    
    @objc private func onBtnClicked(_ sender: UIButton) {
        changeSelectedBtn(sender)
        scrollBtnToCenter(sender: sender)
        if mTitleConfig.titleViewStyle != .tabTitleViewStyleDefault {
            setIndicatorViewTransformWithTargetBtn(sender)
        }
        mTitleViewDelegate.selectPageTitleView(self, withIndex: mSelectedIndex)
    }
}

extension TabTitleView {
    public func setPageTitleViewWithProgress(_ progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        let originalBtn = mBtnArr[originalIndex]
        let targetBtn = mBtnArr[targetIndex]
        
        scrollBtnToCenter(sender: targetBtn)
        
        if progress > 0.6 {
            changeSelectedBtn(targetBtn)
        }
        
        if mTitleConfig.titleViewStyle != .tabTitleViewStyleDefault {
            setIndicatorViewTransformWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        }
    }
    
    public func resetPageTitleViewTitle(_ title: String, ofIndex index: Int) {
        if index < mTitleArr.count {
            let btn = mBtnArr[index]
            btn.setTitle(title, for: .normal)
        }
    }
}

extension TabTitleView {
    private func widthWithString(_ str: String, font: UIFont) -> CGFloat {
        return str.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size.width
    }
    
    private func heightWithString(_ str: String, font: UIFont) -> CGFloat {
        return str.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size.height
    }
    
    private func getRGBWithColor(_ color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red, green, blue)
    }
}

