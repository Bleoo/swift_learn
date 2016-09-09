//
//  LoadingView.swift
//  BmobTest
//
//  Created by TDC on 16/9/8.
//  Copyright © 2016年 TDC. All rights reserved.
//
/*常用动画的 keyPath
transform.rotation：旋转动画。
transform.rotation.x：按x轴旋转动画。
transform.rotation.y：按y轴旋转动画。
transform.rotation.z：按z轴旋转动画。
transform.scale：按比例放大缩小动画。
transform.scale.x：在x轴按比例放大缩小动画。
transform.scale.y：在y轴按比例放大缩小动画。
transform.scale.z：在z轴按比例放大缩小动画。
position：移动位置动画。
opacity：透明度动画。
*/

import UIKit

class LoadingView: UIView {
    
    enum ViewType{
        case dot
        case line
        case circle
    }
    
    init(type: ViewType){
        super.init(frame: UIScreen.mainScreen().bounds)
        
        // 灰色正方圆角底图
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.bounds = CGRectMake(0, 0, 100, 100)
        replicatorLayer.cornerRadius = 10.0
        replicatorLayer.position = center
        replicatorLayer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2).CGColor
        layer.addSublayer(replicatorLayer)
        
        switch type {
        case .dot:
            // 灰色圆点
            let dotLayer = CALayer()
            dotLayer.bounds = CGRectMake(0, 0, 15, 15)
            dotLayer.position = CGPoint(x: 15, y: replicatorLayer.frame.size.height/2)
            dotLayer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6).CGColor
            dotLayer.cornerRadius = 7.5
            replicatorLayer.addSublayer(dotLayer)
            // 平移为3个圆点子集
            replicatorLayer.instanceCount = 3
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(replicatorLayer.frame.size.width/3, 0, 0)
            
            // 缩放动画
            let anim = CABasicAnimation(keyPath: "transform.scale")
            anim.autoreverses = true
            anim.duration = 1.2
            anim.fromValue = 1
            anim.toValue = 0
            anim.repeatCount = MAXFLOAT
            dotLayer.addAnimation(anim, forKey: nil)
            replicatorLayer.instanceDelay = 1.2 / 3
            dotLayer.transform = CATransform3DMakeScale(0, 0, 0)
            
            break
        case .line:
            let lineLayer = CALayer()
            lineLayer.bounds = CGRectMake(0, 0, 5, 50)
            lineLayer.position = CGPoint(x: 28, y: replicatorLayer.frame.size.height - 30)
            lineLayer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6).CGColor
            lineLayer.cornerRadius = 2.5
            replicatorLayer.addSublayer(lineLayer)
            replicatorLayer.instanceCount = 4
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(15, 0, 0)
            
            let anim = CABasicAnimation(keyPath: "position.y")
            anim.duration = 1
            anim.toValue = 30
            anim.autoreverses = true
            anim.repeatCount = MAXFLOAT
            lineLayer.addAnimation(anim, forKey: nil)
            replicatorLayer.instanceDelay = 1 / 4
            
            break
        case .circle:
            // 灰色圆点
            let dotLayer = CALayer()
            dotLayer.bounds = CGRectMake(0, 0, 10, 10)
            dotLayer.position = CGPoint(x: 50, y: 20)
            dotLayer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6).CGColor
            dotLayer.cornerRadius = 5
            replicatorLayer.addSublayer(dotLayer)
            // 平移为10个圆点子集
            replicatorLayer.instanceCount = 10
            replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(2 * M_PI / 10), 0, 0, 1)
            
            // 缩放动画
            let anim = CABasicAnimation(keyPath: "transform.scale")
            anim.duration = 1.2
            anim.fromValue = 1
            anim.toValue = 0.1
            anim.repeatCount = MAXFLOAT
            dotLayer.addAnimation(anim, forKey: nil)
            replicatorLayer.instanceDelay = 1.2 / 10
            dotLayer.transform = CATransform3DMakeScale(0, 0, 0)
            
            break
        }
        
    }
    
    func dismiss(){
        removeFromSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}