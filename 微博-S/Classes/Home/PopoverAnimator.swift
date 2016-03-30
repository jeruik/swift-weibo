//
//  PopoverAnimator.swift
//  微博-S
//
//  Created by nimingM on 16/3/10.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

// 定义常量保存通知名
let popAnimWillShow = "popAnimWillShow"
let popAnimWillDismiss = "popAnimWillDismiss"

class PopoverAnimator: NSObject , UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    // 定义变量记录是否展开
    var isPresent:Bool = false
    var presentFrame = CGRectZero
    
    // 实现代理方法
    // 这个代理方法是用来专门负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    /**
     实现了这个代理方法，系统自带弹出动画就没有了，所有动画需要自己手动实现
     
     - parameter presented:  展开的视图
     - parameter presenting: 发起的视图
     
     - returns: 返回，谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        // 展开了，发个通知
        NSNotificationCenter.defaultCenter().postNotificationName(popAnimWillShow, object: self)
        return self
    }
    
    // dismiss 动画处理。同上
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        // dismiss了，发个通知
        NSNotificationCenter.defaultCenter().postNotificationName(popAnimWillDismiss, object: self)
        return self
    }
    
    // 动画时长 0.5
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /**
     告诉系统动画，无论是展开还是合拢都会调用这个方法
     
     - parameter transitionContext: 上下文里面保存了动画所需要的参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent { // 展开了
            
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.000001)
            
            // 将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            
            // 设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            // 执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                // 清空transform 不然会叠加
                toView.transform = CGAffineTransformIdentity // 复原
                
                }) {(_) -> Void in
                  // 动画执行完毕告诉系统
                    transitionContext.completeTransition(true)
            }
        } else {
            // dismiss了
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                // 注意:由于CGFloat是不准确的, 所以如果写0.0会没有动画
                // 压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })
        }
    }
    
}



















































