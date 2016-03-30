//
//  HomeRefreshControl.swift
//  微博-S
//
//  Created by nimingM on 16/3/30.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {
    
    override init() {
        super.init()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        // 添加子控件
        addSubview(refreshView)
        
        // 布局子控件
        refreshView.xmg_AlignHorizontal(type: XMG_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
    }
    
    // MARK: - 懒加载
    private lazy var refreshView: homeRefreshView = homeRefreshView.refreshView()
}

class homeRefreshView: UIView {
    class func refreshView() -> homeRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshControl", owner: nil, options: nil).last as! homeRefreshView
    }
}