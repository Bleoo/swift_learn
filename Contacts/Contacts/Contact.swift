//
//  Contact.swift
//  Contacts
//
//  Created by TDC on 16/8/23.
//  Copyright © 2016年 TDC. All rights reserved.
//

import Foundation

class Contact : NSObject {
    var image: String?
    var name: String?
    var phone: String?
    
    init(image: String, name: String, phone: String){
        self.image = image
        self.name = name
        self.phone = phone
    }
    
}