//
//  MessageTableViewController.swift
//  微博-S
//
//  Created by nimingM on 16/3/8.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
        }
    }
}
