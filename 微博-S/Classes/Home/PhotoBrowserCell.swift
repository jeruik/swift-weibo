//
//  PhotoBrowserCell.swift
//  微博-S
//
//  Created by nimingM on 16/3/30.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    
    var imageURL:NSURL? {
        didSet {
             iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
                self.setImageViewPostion()
            }
        }
    }
    
    private func setImageViewPostion() {
        // 宽高比计算图片尺寸
        let size = self.displaySize(iconView.image!)
        // 判断图片的高度是否大于屏幕的高度
        if size.height < UIScreen.mainScreen().bounds.height {
            // 能全屏显示 居中
            iconView.frame = CGRect(origin: CGPointZero, size: size);
            // 处理居中
            let y = (UIScreen.mainScreen().bounds.height - size.height) / 2
            self.scrollview.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        }else{
            // 2.1大于 长图 --> y = 0, 设置scrollview的滚动范围为图片的大小
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            scrollview.contentSize = size
        }
    }
    
    private func displaySize(image:UIImage) -> CGSize {
        // 拿到图片的宽高比
        let scale = image.size.height / image.size.width
        let width = UIScreen.mainScreen().bounds.width * scale
        let heigt = width * scale
        
        return CGSize(width: width, height: heigt)
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        // 1.初始化UI
        setupUI()
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        scrollview.addSubview(iconView)
        contentView.addSubview(scrollview)
        
        // 2.布局子控件
        scrollview.frame = UIScreen.mainScreen().bounds
        
    }
    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = UIScrollView()
    private lazy var iconView: UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
