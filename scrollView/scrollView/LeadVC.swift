//
//  LeadVC.swift
//  scrollView
//
//  Created by TDC on 16/8/19.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class LeadVC: UIViewController, UIScrollViewDelegate {
    
    var width = UIScreen.mainScreen().bounds.width
    var height = UIScreen.mainScreen().bounds.height
    
    let pageControl: UIPageControl = UIPageControl()
    var button: UIButton!

    override func viewDidLoad() {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        scrollView.contentSize = CGSize(width: width * 4, height: height)
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        for i in 1...4 {
            let imageView = UIImageView(image: UIImage(named: "\(i).jpg"))
            imageView.frame = CGRectMake(CGFloat(i-1) * width, 0, width, height)
            scrollView.addSubview(imageView)
        }
        
        pageControl.center = CGPoint(x: width/2, y: height - 30)
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        pageControl.pageIndicatorTintColor = UIColor.cyanColor()
        view.addSubview(pageControl)
    }
    
    //UIScrollViewDelegate的代理方法
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = index
        
        if index == 3 {
            if button == nil {
                button = UIButton()
                button.setTitle("that is scrollView", forState: UIControlState.Normal)
                button.backgroundColor = UIColor.blueColor()
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.addTarget(self, action: "jumpToMain", forControlEvents: UIControlEvents.TouchUpInside)
                view.addSubview(button)
            }
            button.frame = CGRectMake(0, height, width, 50)
            button.alpha = 0
            
            UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.button.frame = CGRectMake(0, self.height - 100, self.width, 50)
                self.button.alpha = 1
                }, completion: nil)
        }
    }
    
    func jumpToMain(){
        presentViewController(ViewController(), animated: true, completion: nil)
    }
}
