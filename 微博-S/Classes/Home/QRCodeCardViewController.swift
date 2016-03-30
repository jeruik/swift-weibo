//
//  QRCodeCardViewController.swift
//  微博-S
//
//  Created by nimingM on 16/3/11.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

import UIKit

class QRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的名片"
        view.addSubview(iconView)
    
        // 布局容器
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        iconView.backgroundColor = UIColor.redColor()

        // 生成二维码
        let qrcodeImage = creatQRCodeImage()
        
        // 设置图片
        iconView.image = qrcodeImage
    }
    
    private func creatQRCodeImage() ->UIImage {
        // 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 还原滤镜默认属性
        filter?.setDefaults()
        
        // 设置生成二维码的属性
        filter?.setValue("小菜".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        
        // 从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        
        // 取得图片
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 300)
        
        //创建头像
        let icon = UIImage(named: "11")
        
        // 合成头像并返回
        return creteImage(bgImage, iconImage: icon!)
    }
    /// 合成图片
    private func creteImage(bgImage:UIImage, iconImage:UIImage) ->UIImage {
        UIGraphicsBeginImageContext(bgImage.size)
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        
        // 绘制头像
        let width:CGFloat = 50
        let height:CGFloat = width
        let x = (bgImage.size.width - width)*0.5
        let y = (bgImage.size.height - height)*0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        
        // 取出图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 记得关闭上下文
        UIGraphicsEndPDFContext()
        
        return newImage
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
   
    }
    
    // MARK: - 懒加载
    private lazy var iconView: UIImageView = UIImageView()
}
