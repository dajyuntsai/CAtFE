//
//  TabContentView.swift
//  CustomTabLayout
//
//  Created by Ninn on 2020/1/13.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

@objc public protocol TabContentViewDelegate: NSObjectProtocol {
    // change titleView state when scroll contentView
    func scrollPageContentView(_ pageContentView: TabContentView,
                               progress: CGFloat,
                               originalIndex: Int,
                               targetIndex: Int)
    // get offet of contentView
    @objc optional func getPageContentView(_ pageContentView: TabContentView, offsetX: CGFloat)
}

public class TabContentView: UIView {
    
    // contentView是否可以滾動
    var mScrollSwitch: Bool
    
    weak var mContentViewDelegate: TabContentViewDelegate?
    
    private let mParentVC: UIViewController
    private let mChildVCs: [UIViewController]?
    private let mChildViews: [UIView]
    
    private var mScrollView: UIScrollView!
    
    private var mCurrentOffsetX: CGFloat = 0
    
    // 點擊title來滾動頁面
    private var mIsClickTitle: Bool = false
    
    public init(frame: CGRect,
                parentVC: UIViewController,
                childVCs: [UIViewController]?,
                childViews: [UIView],
                delegate: TabContentViewDelegate?,
                scrollSwitch: Bool = true) {
        mScrollSwitch = scrollSwitch
        if delegate == nil && scrollSwitch == true {
            mScrollSwitch = false
        }
        mContentViewDelegate = delegate
        mParentVC = parentVC
        mChildVCs = childVCs
        var getViews = childViews
        if getViews.count == 0 && childVCs != nil {
            for VCs in childVCs! {
                getViews.append(VCs.view)
            }
        }
        mChildViews = getViews
        
        super.init(frame: frame)
        initScrollView()
        initContent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initScrollView() {
        mScrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        mScrollView.showsVerticalScrollIndicator = false
        mScrollView.showsHorizontalScrollIndicator = false
        mScrollView.alwaysBounceHorizontal = true
        mScrollView.isPagingEnabled = true
        mScrollView.bounces = false
        mScrollView.delegate = self
        
        let viewCount = mChildVCs != nil ? mChildVCs!.count : mChildViews.count
        mScrollView.contentSize = CGSize(width: mScrollView.frame.width * CGFloat(viewCount),
                                         height: mScrollView.frame.size.height)
        if !mScrollSwitch {
            mScrollView.isScrollEnabled = false
        }
        addSubview(mScrollView)
    }
    
    private func initContent() {
        var tempX: CGFloat = 0
        func addContent(view: UIView) {
            view.frame = CGRect(origin: CGPoint(x: tempX, y: 0), size: self.frame.size)
            mScrollView.addSubview(view)
            tempX += self.frame.size.width
        }
        if let childVCs = mChildVCs {
            for childVC in childVCs {
                mParentVC.addChild(childVC)
                addContent(view: childVC.view)
            }
        } else {
            for view in mChildViews {
                addContent(view: view)
            }
        }
    }
    
    func getChildVC(at index: Int) -> UIViewController? {
        guard mChildVCs != nil && mChildVCs?.count ?? -1 > index else {
            return nil
        }
        return mChildVCs?[index]
    }
}

public extension TabContentView {
    func setPageContentViewWithIndex(_ index: Int) {
        mIsClickTitle = true
        weak var weakSelf = self
        let offset = CGFloat(index) * mScrollView.frame.size.width
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf?.mScrollView.contentOffset = CGPoint(x: offset, y: 0)
        }) { _ in
            if let delegate = weakSelf?.mContentViewDelegate {
                if delegate.responds(to: #selector(TabContentViewDelegate.getPageContentView(_:offsetX:))) {
                    delegate.getPageContentView!(weakSelf!, offsetX: offset)
                }
            }
        }
    }
}

// MARK: - UIScrollView Delagate
extension TabContentView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        mIsClickTitle = false
        mCurrentOffsetX = scrollView.contentOffset.x
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if mContentViewDelegate!.responds(to: #selector(TabContentViewDelegate.getPageContentView(_:offsetX:))) {
            mContentViewDelegate!.getPageContentView!(self, offsetX: scrollView.contentOffset.x)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mIsClickTitle {
            return
        }
        
        var progress: CGFloat = 0
        var originalIndex: Int = 0
        var targetIndex: Int = 0
        
        let curOffsetX = scrollView.contentOffset.x
        let scrollViewW = mScrollView.frame.size.width
        
        let contentsCount = mChildVCs != nil ? mChildVCs!.count : mChildViews.count
        
        if curOffsetX > mCurrentOffsetX { // left
            
            progress = curOffsetX / scrollViewW - floor(curOffsetX / scrollViewW)
            originalIndex = Int(floor(curOffsetX / scrollViewW))
            targetIndex = originalIndex + 1
            if targetIndex >= contentsCount {
                progress = 1
                targetIndex = contentsCount - 1
            }
            if curOffsetX - mCurrentOffsetX == scrollViewW {
                progress = 1
                targetIndex = originalIndex
            }
        } else {    // right
            progress = 1 - (curOffsetX / scrollViewW - floor(curOffsetX / scrollViewW))
            targetIndex = Int(floor(curOffsetX / scrollViewW))
            originalIndex = targetIndex + 1
            if originalIndex >= contentsCount {
                originalIndex = contentsCount - 1
            }
        }
        
        mContentViewDelegate?.scrollPageContentView(self, progress: progress,
                                                    originalIndex: originalIndex,
                                                    targetIndex: targetIndex)
    }
}
