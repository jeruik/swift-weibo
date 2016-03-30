//
//  UIBarButtonItem+Category.swift
//  微博-S
//
//  Created by nimingM on 16/3/9.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func creatBarButtonItem(imageName: String, target: AnyObject?, action:Selector) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        
        return UIBarButtonItem(customView: btn)
        print("dfdas")
    }

}
