//
//  NSUser.swift
//  JCApp
//  Created by jacky on 2017/12/11.
//  Copyright © 2017年 wxl. All rights reserved.
//

import Foundation
import UIKit
class NSUser{
    /**
     存储
     */
    class func setNormalDefault(key:String,value:Any?){
        if value == nil{
            UserDefaults.standard.removeObject(forKey: key)
        }else{
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
    }
    /**
     通过key移除存储
     */
    class func removeNormalDefault(key:String){
        if key != nil{
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    /**
     通过key查找value
     */
    class func getNormalDefault(key:String) -> Any?{
        return UserDefaults.standard.value(forKey:key)
    }
    
}
