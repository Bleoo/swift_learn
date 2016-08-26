//
//  newSearchBar.swift
//  SearchBar
//
//  Created by TDC on 16/8/25.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class NewSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchControllerDelegate, UISearchResultsUpdating {
    
    var width = UIScreen.mainScreen().bounds.width
    
    @IBOutlet weak var namesTV: UITableView!
    
    var searchController: UISearchController?
    
    var names = [String]()
    var filterNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        names.append("UIViewController")
        names.append("UITableViewDataSource")
        names.append("UITableViewDelegate")
        names.append("UITableView")
        
        // 必须使用该方法初始化,否则searchBar不可见
        searchController = UISearchController(searchResultsController: nil)
        searchController!.delegate = self
        searchController!.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        namesTV.tableHeaderView = searchController?.searchBar
        searchController?.loadViewIfNeeded()
        // 设置结果是否可以点击
        searchController?.dimsBackgroundDuringPresentation = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searchController!.active {
            return filterNames.count
        }
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("newNameCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newNameCell")
        }
        // 判断搜索状态是否激活
        if searchController!.active {
            cell?.textLabel?.text = filterNames[indexPath.row]
        } else {
            cell?.textLabel?.text = names[indexPath.row]
        }
        return cell!
    }
    
    // UISearchResultsUpdating的搜索方法
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterNames = names.filter(){$0.rangeOfString(searchController.searchBar.text!) != nil}
        namesTV.reloadData()
    }
    
}