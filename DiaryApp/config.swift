//
//  config.swift
//  hsh
//
//  Created by guest on 2018/6/1.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

#if DEBUG
    func dlog<T>(t:T){print(t)}
#else
    func dlog<T>(t:T){}
#endif
//MARK: - UIDevice延展
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}

class UserHelper {
    //获取今天日期
    
    static func getTodayTime() -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd"
        return dateFormat.string(from: Date())
    }
    
    //返回是否可以弹出
    static func getRepayNoticeCanShow() -> Bool {
        let defaults = UserDefaults()
        let dateStr = defaults.object(forKey: "popWindowOnceADay1") as? String
        return dateStr == getTodayTime() ? false : true //判断时间是否相同
    }
}
struct sjname {
    static let sjarr = ["Drink 1.5-2l of plain water every day","Drink scented tea every afternoon","Eat calcium tablets or drink milk every day","Keep exercising or walking for 30 minutes every day.","Soak your feet in hot water every day and give them a proper massage","Exercise for half an hour every morning","Sleep 30 minutes after lunch","Have a nutritious breakfast at 7:9","Go to bed before ten","Don't eat late night, drink, or smoke","Read for at least half an hour every day","A cup of coffee a day is much better","Soak your feet in hot water every day and give them a proper massage.","Cold water is good for washing your face","Drink a glass of milk after exercise","Eating bitterness is good for health"]
}

func createRandomMan(start: Int, end: Int) ->() ->Int?{
    //根据参数初始化可选值数组
    var nums = [Int]();
    for i in start...end{
        nums.append(i)
    }
    
    func randomMan() -> Int! {
        if !nums.isEmpty {
            //随机返回一个数，同时从数组里删除
            let index = Int(arc4random_uniform(UInt32(nums.count)))
            return nums.remove(at: index)
        }
        else {
            //所有值都随机完则返回nil
            return nil
        }
    }
    
    return randomMan
}
//方法
func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func kRGBColorFromHex(hex: String) -> (UIColor) {
    var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.gray
    }
    
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}
//常量
let YJSM = "http://route.showapi.com/268-2"
let EJSM = "http://route.showapi.com/268-3"
let SJSM = "http://route.showapi.com/268-4"
let QGJD = "http://route.showapi.com/268-1"
//let ss_mmdivideLineHeight:CGFloat = 0.5                          /* 按钮与按钮之间的分割线高度 */
//let ss_mmscreenBounds = UIScreen.main.bounds                   /* 屏幕Bounds */
//let ss_mmscreenSize   = ss_mmscreenBounds.size                 /* 屏幕大小 */
//let ss_mmscreenWidth  = ss_mmscreenSize.width                  /* 屏幕宽度 */
//let ss_mmscreenHeight = ss_mmscreenSize.height                 /* 屏幕高度 */
//let ss_mmbuttonHeight:CGFloat = 48.0 * ss_mmscreenWidth / 375  /* button高度 */
//let ss_mmtitleHeight:CGFloat = 35.0 * ss_mmscreenWidth / 375   /* 标题的高度 */
//let ss_mmbtnPadding:CGFloat = 0.5 * ss_mmscreenWidth / 375       /* 取消按钮与其他按钮之间的间距 */
//let ss_mmdefaultDuration = 0.3
//let ss_mmcardHeight:CGFloat = 120.0 * ss_mmscreenWidth / 375   /* 单行card的高度 */
//let ss_mmitemHeight:CGFloat = 100.0 * ss_mmscreenWidth / 375   /* 单个item的高度 */
//let ss_mmitemwidth:CGFloat = 93.75 * ss_mmscreenWidth / 375    /* 单个item的宽度F6D43D */D7E4D2
let QQ_APPID = "100508229"
let WX_APPID = "wxb3a0370fa1250dd5"
let WX_APPSecret = "2d158c35d26e9edc584e3b421f893845"
let SHOWAPIAPPID = "66950"
let SHOWAPISECRET = "3c52b03754c54e9eb6832b3a46802528"
let MAIN_NAVC_COLOR           = UIColorFromRGB(rgbValue: 0xFA7496)
let MAIN_BACK_COLOR           = UIColorFromRGB(rgbValue: 0xf0eff5)
let MAIN_BACKs_COLOR           = UIColorFromRGB(rgbValue: 0xD7E4D2)
let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
//常量
let ss_mmdivideLineHeight:CGFloat = 0.5                          /* 按钮与按钮之间的分割线高度 */
let ss_mmscreenBounds = UIScreen.main.bounds                   /* 屏幕Bounds */
let ss_mmscreenSize   = ss_mmscreenBounds.size                 /* 屏幕大小 */
let ss_mmscreenWidth  = ss_mmscreenSize.width                  /* 屏幕宽度 */
let ss_mmscreenHeight = ss_mmscreenSize.height                 /* 屏幕高度 */
let ss_mmbuttonHeight:CGFloat = 48.0 * ss_mmscreenWidth / 375  /* button高度 */
let ss_mmtitleHeight:CGFloat = 35.0 * ss_mmscreenWidth / 375   /* 标题的高度 */
let ss_mmbtnPadding:CGFloat = 0.5 * ss_mmscreenWidth / 375       /* 取消按钮与其他按钮之间的间距 */
let ss_mmdefaultDuration = 0.3
let ss_mmcardHeight:CGFloat = 120.0 * ss_mmscreenWidth / 375   /* 单行card的高度 */
let ss_mmitemHeight:CGFloat = 100.0 * ss_mmscreenWidth / 375   /* 单个item的高度 */
let ss_mmitemwidth:CGFloat = 93.75 * ss_mmscreenWidth / 375    /* 单个item的宽度 */

let COLOR0 = UIColorFromRGB(rgbValue: 0x6C83F8)
let COLOR1 = UIColorFromRGB(rgbValue: 0x8767F8)
let COLOR2 = UIColorFromRGB(rgbValue: 0xBF9FC1)
let COLOR3 = UIColorFromRGB(rgbValue: 0xBF1DC1)
let COLOR4 = UIColorFromRGB(rgbValue: 0x311D5E)
let COLOR5 = UIColorFromRGB(rgbValue: 0xDDE85E)
let COLOR6 = UIColorFromRGB(rgbValue: 0xDD0000)
let COLOR7 = UIColorFromRGB(rgbValue: 0x755C64)
let COLOR8 = UIColorFromRGB(rgbValue: 0x1FC3AE)


let hCREEN_WIDTH              = UIScreen.main.bounds.width
let hCREEN_HEIGHT             = UIScreen.main.bounds.height
let hcRect             = UIScreen.main.bounds
let ItemHeight = YHHeight/3
let ItemWidth = YHWidth-20
let MAIN_BOAY_COLOR           = UIColorFromRGB(rgbValue: 0x333333) //正文 重要文字
