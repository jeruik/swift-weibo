//
//  UserAccount.swift
//  微博-S
//
//  Created by nimingM on 16/3/16.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

// Swift2.0 打印对象需要重写CustomStringConvertible协议中的description
class UserAccount: NSObject, NSCoding{
    
    /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    /// access_token的生命周期，单位是秒数。
    var expires_in: NSNumber? {
        didSet {
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    /// 当前授权用户的UID。
    var uid:String?
    
    /// 保存用户过期时间
    var expires_Date: NSDate?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    /// 用户昵称
    var screen_name: String?
    
    override init() {

    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        /*
        access_token = dict["access_token"] as? String
        // 直接赋值, 不会调用didSet
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
        */
        
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid","avatar_large", "screen_name"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    
    func loadUserInfon(finished: (account: UserAccount?, error: NSError?) ->()) {
        
        let path = "2/users/show.json"
        let params = ["access_token":access_token!, "uid":uid!]
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            
            // 判断字典是否有值
            if let dict = JSON as? [String: AnyObject] {
                
                // 从字典里面取出来
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                
                // 保存到模型
                finished(account: self, error: nil)
                return
            }
                // 不保存
                finished(account: nil, error: nil)
            
            }) { (_, error) -> Void in
                // 不保存
                finished(account: nil, error: error)
        }
    }
    
    // 返回用户是否登陆
    class func userLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    }
    
    // MARK: - 保存和读取 keyed
    func saveAccount() {

        NSKeyedArchiver.archiveRootObject(self, toFile: "account.plist".cacheDir())
    }
    
    // MARK: - 读取授权模型
    static var account: UserAccount?   // 定义单例
    class func loadAccount() -> UserAccount? {
        
        // 1.判断是否已经加载过
        if account != nil {
            // 模型有值， 直接返回
        }
        
        // 2.加载授权模型
        account = NSKeyedUnarchiver.unarchiveObjectWithFile("account.plist".cacheDir()) as? UserAccount
        
        // 3.判断是否过期
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            // 已经过期了
            return nil
        }
        return account
    }
    
    // 存
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    // 读取
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name")  as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large")  as? String
    }
    
}



