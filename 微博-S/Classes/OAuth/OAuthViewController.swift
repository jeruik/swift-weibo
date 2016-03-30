//
//  OAuthViewController.swift
//  微博-S
//
//  Created by nimingM on 16/3/16.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    let WB_App_Key = "3069251893"
    let WB_App_Secret = "dd942139d5c74df0b1377a8b3a6ce852"
//    let WB_App_Key = "2663602480"
//    let WB_App_Secret = "f8e22720901e6fc7510900f36511cb6e"
    let WB_redirect_uri = "http://www.baidu.com"
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化导航条
        navigationItem.title = "小菜的swift微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
    
        // 获取未授权的requsetToken
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let requset = NSURLRequest(URL: url!)
        webView.loadRequest(requset)
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        return web
    }()
}

extension OAuthViewController: UIWebViewDelegate {
    
    /*
    加载授权界面: https://api.weibo.com/oauth2/authorize?client_id=2624860832&redirect_uri=http://www.520it.com
    
    跳转到授权界面: https://api.weibo.com/oauth2/authorize
    
    授权成功: http://www.520it.com/?code=91e779d15aa73698cbbb72bc7452f3b3
    
    取消授权: http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
    */
    
    // ture 表示正常加载， 反之则不加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.判断是否是授权回调页面，如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        print(urlStr)
        if !urlStr.hasPrefix(WB_redirect_uri) {
            // 没有包含回调地址就继续加载
            return true
        }
        
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            // 如果包含代表授权成功
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            // 拿到code发送请求换取accessToken
            loadAccessToken(code!)
            
        } else {
            // 取消授权了
            close()
        }
        return false
    }
    
    
    private func loadAccessToken(code: String)
    {
        // 1.定义路径
        let path = "oauth2/access_token"
        // 2.封装参数
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_redirect_uri]
        // 3.发送POST请求
        NetworkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, JSON) -> Void in

            let account = UserAccount(dict: JSON as! [String : AnyObject])
            
            account.loadUserInfon({ (account, error) -> () in
                if account != nil {
                    // 2.归档模型
                    account!.saveAccount()
                    
                    // 3.去欢迎界面
                    NSNotificationCenter.defaultCenter().postNotificationName(XMGSwitchRootViewControllerKey, object: false)
                }
                SVProgressHUD.showInfoWithStatus("网络不给力", maskType: SVProgressHUDMaskType.Black)
            })
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showInfoWithStatus("正在加载", maskType: SVProgressHUDMaskType.Black)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
























