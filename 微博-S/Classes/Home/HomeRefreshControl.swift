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
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    /// 定义变量记录是否需要旋转监听
    private var rotationArrowFlag = false
    /// 定义变量记录当前是否正在执行圈圈动画
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //        print(frame.origin.y)
        
        // 过滤掉不需要的数据
        if frame.origin.y >= 0
        {
            return
        }
        
        // 判断是否已经触发刷新事件
        if refreshing && !loadingViewAnimFlag
        {
            print("圈圈动画")
            loadingViewAnimFlag = true
            // 显示圈圈, 并且让圈圈执行动画
            refreshView.startAnim()
            return
        }
        
        if frame.origin.y >= -50 && rotationArrowFlag
        {
            print("翻转回来")
            rotationArrowFlag = false
            refreshView.rotationArrow(rotationArrowFlag)
        }else if frame.origin.y < -50 && !rotationArrowFlag
        {
            print("翻转")
            rotationArrowFlag = true
            refreshView.rotationArrow(rotationArrowFlag)
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        // 结束刷新后关闭动画
        refreshView.stopLoadingViewAnim()
        loadingViewAnimFlag = false
    }
    
    // MARK: - 懒加载
    private lazy var refreshView: homeRefreshView = homeRefreshView.refreshView()
}

class homeRefreshView: UIView {
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var loadingView: UIImageView!
    class func refreshView() -> homeRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshControl", owner: nil, options: nil).last as! homeRefreshView
    }
    
    
    /**
     旋转箭头
     */
    func rotationArrow(flag: Bool) {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { () -> Void in
            self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, CGFloat(angle))
        }
    }
    
    /**
     开始动画
     */
    func startAnim() {
        tipView.hidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        // 设置默认属性，执行完毕就移除
        anim.removedOnCompletion = false
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    /**
    *  停止转圈动画
    */
    
    func stopLoadingViewAnim() {
        tipView.hidden = false
        loadingView.layer.removeAllAnimations()
    }

}