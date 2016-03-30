
//
//  StatusPictureView.swift
//  微博-S
//
//  Created by nimingM on 16/3/29.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit
import SDWebImage
class StatusPictureView: UICollectionView {
    
    var status: Status? {
        didSet {
            reloadData()
        }
    }
    private var pictureLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        // 注册cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: XMGPictureViewCellReuseIdentifier)
        
        dataSource = self
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化配图相关属性
    private func setupPictureView() {

    }
    /**
     计算配图的尺寸
     */
    func calculateImageSize() -> CGSize
    {
        // 1.取出配图个数
        let count = status?.storedPicURLS?.count
        // 2.如果没有配图zero
        if count == 0 || count == nil
        {
            return CGSizeZero
        }
        // 3.如果只有一张配图, 返回图片的实际大小
        if count == 1
        {
            // 3.1取出缓存的图片
            let key = status?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            
            pictureLayout.itemSize = image.size
            // 3.2返回缓存图片的尺寸
            return image.size
        }
        // 4.如果有4张配图, 计算田字格的大小
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
    }
        
    }
    
    class PictureViewCell: UICollectionViewCell {
        // 定义接收外界属性的数据
        var imageUrl:NSURL? {
            didSet {
                iconImageView.sd_setImageWithURL(imageUrl)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            // 添加子控件
            contentView.addSubview(iconImageView)
            
            // 布局子控件
            iconImageView.xmg_Fill(contentView)
        }
        
        // MARK: - 懒加载
        private lazy var iconImageView: UIImageView = UIImageView()
    }



extension StatusPictureView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XMGPictureViewCellReuseIdentifier, forIndexPath: indexPath) as! PictureViewCell
        cell.imageUrl = status?.storedPicURLS![indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
}








