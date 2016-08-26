//
//  ViewController.swift
//  SearchBar
//
//  Created by TDC on 16/8/25.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tableVeiw: UITableView!
    
    var names = [String]()
    var filterNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        names.append("UIViewController")
        names.append("UITableViewDataSource")
        names.append("UITableViewDelegate")
        names.append("UITableView")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == searchDisplayController?.searchResultsTableView {
            return filterNames.count
        }
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("NameCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "nameCell")
        }
        if tableView == searchDisplayController?.searchResultsTableView {
            cell?.textLabel?.text = filterNames[indexPath.row]
        } else {
            cell?.textLabel?.text = names[indexPath.row]
        }
        return cell!
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool{
        filterNames = names.filter(){$0.rangeOfString(searchString!) != nil}
        return true
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        navigationController?.pushViewController(NewSearchVC(), animated: true)
//    }

}

