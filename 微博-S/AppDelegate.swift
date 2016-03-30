//
//  AppDelegate.swift
//  微博-S
//
//  Created by nimingM on 16/3/8.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit
import SVProgressHUD

// 切换控制器通知
let XMGSwitchRootViewControllerKey = "XMGSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    // 1.获取主界面
    private func defaultController() -> UIViewController {
        
        // 检测用户是否登陆
        if UserAccount.userLogin() {
            // 如果登陆了  需要更新，显示新特性，不需要更新显示欢迎界面
            return isNewupdate() ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        // 如果没有登陆，显示未登录的主界面
        return MainViewController()
    }
    
    // 2.是否需要更新
    private func isNewupdate() ->Bool {
        // 1.获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取以前的软件版本号 --> 从本地文件中读取(以前自己存储的)
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
         print("current = \(currentVersion) sandbox = \(sandboxVersion)")
        
        // 比较版本号  降序 当前版本号大于沙盒版本号
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            print("要更新")
            return true
        }
        
        // 如果当前版本等于或小于（不可能小于） 则不需要更新
        print("不需要更新")
        return false
    }
    
    // 3.切换控制器
    func switchRootViewController(notify: NSNotification){
        //        print(notify.object)
        if notify.object as! Bool
        {
            window?.rootViewController = MainViewController()
        }else
        {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        print(UserAccount.loadAccount())
        
        // 注册通知
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootViewController:", name: XMGSwitchRootViewControllerKey, object: nil)
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        return true
    }
}

