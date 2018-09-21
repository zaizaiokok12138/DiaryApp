//
//  MyRequest.swift
//  JCApp
//
//  Created by jacky on 2017/6/27.
//  Copyright © 2017年 wxl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//开关列表
let mainOneURL = "http://www.dijiadijia.com/face.php"

enum MethodType {
    case get
    case post
}

class MyRequest {
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) -> Void in
            
            switch response.result {
            case .success(let value):
                print("Value:\(value)")
                print("------")
                let swiftyJsonVar = JSON(value)
                dlog(t: "==========错误信息\(response.error)==========")
                dlog(t: "==========二进制文件\(response.data)==========")
                dlog(t: "==========请求地址\(URLString)==========")
                dlog(t: "==========请求体\(response.request)==========")
                finishedCallback(value)
            case .failure(let error):
                dlog(t: error.localizedDescription)
            }

        }
    }
}
