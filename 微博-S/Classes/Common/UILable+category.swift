
//
//  UILable+category.swift
//  微博-S
//
//  Created by nimingM on 16/3/25.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

extension UILabel {
    class func creatLael(color:UIColor,fontSize:CGFloat)->UILabel {
        
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}
