//
//  WebViewController.swift
//  Diary
//
//  Created by 崽崽 on 2018/7/5.
//  Copyright © 2018年 zaizai. All rights reserved.
//

import UIKit
import WebKit
import WechatKit
enum TYPE {
    case Only, Two, Thress
}
class WebViewController: BaseViewController, WKScriptMessageHandler, WKNavigationDelegate{
    var webView : WKWebView!
    var timer:Timer!
    
    enum LDShareType {
        case Session, Timeline, Favorite/*会话, 朋友圈, 收藏*/
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @objc private func handleOrientationChange(notification: Notification) {
        let windth = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        dlog(t: windth)
        dlog(t: height)
        if !(webView != nil){
            return
        }
        // 获取设备方向
        let device = UIDevice.init()
        if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            if device.modelName == "iPhone X"{
                self.webView.frame = CGRect.init(x: 0, y: 88, width: windth, height: height-88-44)
            }else{
                self.webView.frame = CGRect.init(x: 0, y: 0, width: windth, height: height)
            }
        }else if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            if device.modelName == "iPhone X"{
                self.webView.frame = CGRect.init(x: 88, y: 0, width: windth-2*88, height: height)
            }else{
                self.webView.frame = CGRect.init(x: 0, y: 0, width: windth, height: height)
            }
        }else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            if device.modelName == "iPhone X"{
                self.webView.frame = CGRect.init(x: 88, y: 0, width: windth - 2*88, height: height)
            }else{
                 self.webView.frame = CGRect.init(x: 0, y: 0, width: windth, height: height)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.initSubviews()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOrientationChange(notification:)),
                                               name:NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
                                               object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "msgBridge")
        self.webView.navigationDelegate = nil
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initSubviews() {
        
        // 创建配置
        let config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        config.allowsInlineMediaPlayback = true
        //        config.mediaPlaybackAllowsAirPlay //容许播放
        //        config.mediaPlaybackRequiresUserAction  //手动播放
        let userContent = WKUserContentController()
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        userContent.add(self, name: "msgBridge")
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent
        // 高端的自定义配置创建WKWebView
//        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
//        webView = WKWebView.init(frame: CGRect.init(x: 0, y: 88, width: YHWidth, height: YHHeight-88-44), configuration: config)
        let device = UIDevice.init()
        if device.modelName == "iPhone X"{
            webView = WKWebView.init(frame: CGRect.init(x: 0, y: 88, width: YHWidth, height: YHHeight-88-44), configuration: config)
        }else{
            webView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: YHWidth, height: YHHeight), configuration: config)
        }
        // 设置访问的URL
        let strs = NSUser.getNormalDefault(key: "url") as! String
        let url:URL = NSURL.init(string: strs)! as URL
        // 根据URL创建请求
        let requst = NSURLRequest.init(url:url)
        // 设置代理
        webView.navigationDelegate = self
        // WKWebView加载请求
        webView.load(requst as URLRequest)
        webView.backgroundColor = UIColor.black
        // 将WebView添加到当前view
        view.addSubview(webView)
        //        if NSUser.getNormalDefault(key: "first") == nil{
//        let item = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
//        self.navigationItem.leftBarButtonItem = item
        //        }else{
        
        //        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 判断是否是调用原生的
        if "msgBridge" == message.name {
            // 判断message的内容，然后做相应的操作
            self.navigationController?.popViewController(animated: true)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //        if webView.canGoBack{
        //            self.navigationController?.popViewController(animated: true)
        //        }
        let str = navigationAction.request.url?.absoluteString
        
        decisionHandler(WKNavigationActionPolicy.allow)
        if (str?.contains("openurl://test?"))!{
            self.opnedealPayAction(url: str!)
        }else if(str?.contains("share://test?"))! {
            self.sharedealPayAction(url: str!)
        }else if(str?.contains("itunes.apple.com"))!{
            self.appstoredealPayAction(url: str!)
        }
        
        NSLog("在请求发送之前，决定是否跳转。  1")
    }
    func opnedealPayAction(url:String){
        let index = url.index(url.startIndex, offsetBy: 19)
        //        let openurl = url.substring(to: index)
        let openurl = url.substring(from: index)
        let strs = openurl.removingPercentEncoding
        let action = URL.init(string: strs!)
        
        
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(action!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(action!)
        }
    }
    func sharedealPayAction(url:String){
        let array:Array = url.components(separatedBy: "&")
        let str1 = array[0]
        let str2 = array[1]
        //        let str3 = array[2]
        let str4 = array[3]
        let index1 = str1.index(str1.startIndex, offsetBy: 19)
        let openstr1 = str1.substring(from: index1)
        let title1 = openstr1.removingPercentEncoding
        
        
        let index2 = str2.index(str2.startIndex, offsetBy: 8)
        let openstr2 = str2.substring(from: index2)
        let description1 = openstr2.removingPercentEncoding
        
        
        let index3 = str4.index(str4.startIndex, offsetBy: 4)
        let openstr3 = str4.substring(from: index3)
        let url1 = openstr3.removingPercentEncoding
        
        let cards = [
            [
                [
                    "title": "微信好友",
                    "icon": "fenxiang-weixin",
                    "handler": "wxfriend"
                ],
                [
                    "title": "微信朋友圈",
                    "icon": "fenxiang-pengyouquan",
                    "handler": "wxmoment"
                ],
                ]
        ]
        let cancelBtn = [
            "title": "取消",
            "type": "danger"
        ]
        let mmShareSheet = MMShareSheet.init(title: "分  享  至", cards: cards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { (handler) ->() in
            if handler == "wxfriend"{//微信好友
                self.shareURL(to: .Session, title1: title1!, description1: description1!, url1: url1!)
            }else if handler == "wxmoment"{//微信朋友圈
                self.shareURL(to: .Timeline, title1: title1!, description1: description1!, url1: url1!)
            }
        }
        mmShareSheet.present()
    }
    func shareURL(to scene: LDShareType, title1:String, description1:String, url1:String) {
        let message = WXMediaMessage()
        message.title = title1
        message.description = description1
        message.setThumbImage(UIImage())
        
        let obj = WXWebpageObject()
        obj.webpageUrl = url1
        message.mediaObject = obj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        
        switch scene {
        case .Session:
            req.scene = Int32(WXSceneSession.rawValue)
        case .Timeline:
            req.scene = Int32(WXSceneTimeline.rawValue)
        case .Favorite:
            req.scene = Int32(WXSceneFavorite.rawValue)
        }
        WXApi.send(req)
    }
    func appstoredealPayAction(url:String){
        UIApplication.shared.openURL(NSURL.init(string: url)! as URL)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        SJProgressHUD.showWaiting("正在加载...", autoRemove: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SJProgressHUD.dismiss()
        //        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SJProgressHUD.dismiss()
        //        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

