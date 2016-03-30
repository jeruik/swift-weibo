//
//  ProfileTableViewController.swift
//  微博-S
//
//  Created by nimingM on 16/3/8.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
    }
}
