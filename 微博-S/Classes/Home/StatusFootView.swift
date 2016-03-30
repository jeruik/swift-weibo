//
//  StatusFootView.swift
//  微博-S
//
//  Created by nimingM on 16/3/29.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class StatusFooterView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        // 添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        // 布局子控件
        xmg_HorizontalTile([retweetBtn,unlikeBtn,commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - 懒加载
    
    // 顶部名片view
    private lazy var headerView: StatusTableViewTopView = {
        let header = StatusTableViewTopView()
        return header
    }()
    
    private lazy var pictureView: StatusPictureView = {
        let pic = StatusPictureView()
        return pic
    }()
    
    // 转发
    private lazy var retweetBtn: UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")
    
    // 赞
    private lazy var unlikeBtn: UIButton = UIButton.createButton("timeline_icon_unlike", title: "赞")
    
    // 评论
    private lazy var commonBtn: UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")
}

