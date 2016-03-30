//
//  BaseTableViewController.swift
//  微博-S
//
//  Created by nimingM on 16/3/9.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate {
    
//    var userLogin = false
    // 定义属性保存未登录界面
    var userLogin = UserAccount.userLogin()
    var visitorView: VisitorView?
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 内部控制方法
    /**
    创建未登录界面
    */
    private func setupVisitorView()
    {
        // 1.初始化未登录界面
        let customView = VisitorView()
        customView.delegate = self
        //        customView.backgroundColor = UIColor.redColor()
        view = customView
        visitorView = customView
        
    }
    
    // MARK: - VisitorViewDelegate
    func loginBtnWillClick() {
        let nav = UINavigationController()
        nav.addChildViewController(OAuthViewController())
        presentViewController(nav, animated: true, completion: nil)
    }
    func registerBtnWillClick() {
        print(__FUNCTION__)
    }
    
}
