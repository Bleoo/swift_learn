//
//  ToastView.swift
//  BmobTest
//
//  Created by TDC on 16/9/9.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ToastView: UIView {
    
    let width = 200
    let height = 35
    
    init(text: String){
        super.init(frame: CGRectMake(0, 0, CGFloat(width), CGFloat(height)))
        layer.position = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height - 120)
        layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5).CGColor
        layer.cornerRadius = 10
        let label = UILabel(frame: bounds)
        label.text = text
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = NSTextAlignment.Center
        addSubview(label)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.dismiss()
        }
    }
    
    func dismiss(){
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 1
        anim.repeatCount = 1
        // 下面俩句保证remove时不闪烁
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.delegate = self
        layer.addAnimation(anim, forKey: "dismiss")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
