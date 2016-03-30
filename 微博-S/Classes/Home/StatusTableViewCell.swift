//
//  StatusTableViewCell.swift
//  微博-S
//
//  Created by nimingM on 16/3/25.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit
import SDWebImage
let XMGPictureViewCellReuseIdentifier = "XMGPictureViewCellReuseIdentifier"


enum StatusTableViewCellIdentifier:String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    static func cellID(status:Status) -> String {
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }
}

class StatusTableViewCell: UITableViewCell {
    
    /// 保存配图的宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    /// 保存配图的高度约束
    var pictureHeightCons: NSLayoutConstraint?
    /// 保存配图的顶部约束
    var pictureTopCons: NSLayoutConstraint?
    var status:Status? {
        didSet {
            headerView.status = status
            contentLabel.text = status?.text
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
            
            let size = pictureView.calculateImageSize()
            // 1.2设置配图的尺寸
            // 1.1根据模型计算配图的尺寸
            // 注意: 计算尺寸需要用到模型, 所以必须先传递模型
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    /**
     继承的话，重写必须去掉这个 private
     */
    func setupUI() {
        
        // 1.添加子控件

        contentView.addSubview(headerView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        contentView.addSubview(pictureView)
        
        let width = UIScreen.mainScreen().bounds.width
        // 2.布局子控件
        // 2.布局子控件
        headerView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: headerView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
    }
    
    // 用于获取行号
    func rowHeight(status:Status)-> CGFloat {
        self.status = status
        self.layoutIfNeeded()
        return CGRectGetMaxY(footerView.frame)
    }
    

    /// 顶部
    private lazy var headerView: StatusTableViewTopView = StatusTableViewTopView()
    /// 正文
     lazy var pictureView: StatusPictureView = StatusPictureView()
    /// 配图
    lazy var contentLabel:UILabel = {
        let label = UILabel.creatLael(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    /// 底部工具条
    lazy var footerView: StatusFooterView = StatusFooterView()
}



