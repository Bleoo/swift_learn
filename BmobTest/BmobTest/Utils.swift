//
//  Utils.swift
//  BmobTest
//
//  Created by TDC on 16/9/5.
//  Copyright © 2016年 TDC. All rights reserved.
//

import Foundation

extension String  {
    var MD5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
    
    static func random(length: Int) -> String {
        var string = String()
        for _ in 1...length {
            let number = arc4random() % 36
            if number < 10 {
                let figure = arc4random() % 10
                let tempString = String(format: "%d", figure)
                string = string.stringByAppendingString(tempString)
            } else {
                let figure = (arc4random() % 26) + 97
                let tempString = String(format: "%c", figure)
                string = string.stringByAppendingString(tempString)
            }
        }
        return string
    }
}

class Utils: AnyObject {
    
    static let width = UIScreen.mainScreen().bounds.width
    static let height = UIScreen.mainScreen().bounds.height
    
    static let dateFormatter = NSDateFormatter()
    
    static func dateFormat(date: NSDate, format: String) -> String {
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
}
