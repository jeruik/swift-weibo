//
//  DiscoverTableViewController.swift
//  微博-S
//
//  Created by nimingM on 16/3/8.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        }
    }
}
