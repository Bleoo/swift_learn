//
//  User.swift
//  BmobTest
//
//  Created by TDC on 16/8/31.
//  Copyright © 2016年 TDC. All rights reserved.
//

import Foundation

class User: BmobUser {
    
    var sex: Int?
    var books: [DiaryBook]?
    var fans: [User]?
    var follows: [User]?
    var icon: BmobFile?
    var introduction: String?
    var onList: Bool?
    
    static func convert(obj: BmobObject) -> User {
        let user = User.convertWithObject(obj)
        //不支持转化Bool，Int，Float类型,所以 需要手动设置
        user.sex = obj.objectForKey("sex") as? Int
        user.onList = obj.objectForKey("onList") as? Bool
        return user
    }
    
    static func queryUserById(userId: String) -> User? {
        var user: User?
        let query = BmobUser.query()
        query.getObjectInBackgroundWithId(userId) { (obj, error) -> Void in
            if error == nil {
                user = convert(obj)
                print(user)
            }
        }
        return user
    }

    
}