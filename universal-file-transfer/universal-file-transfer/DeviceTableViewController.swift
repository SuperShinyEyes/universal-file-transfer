//
//  DeviceTableViewController.swift
//  universal-file-transfer
//
//  Created by AllConnect Student on 12/03/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation
import UIKit

class DeviceTableViewContoller: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var devices:[String] = ["asd","test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //datasource = self
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        
        UITableViewCell {
        
        let cell = UITableViewCell()
        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        label.text = "Hello world"
        cell.addSubview(label)
        return cell
    }

    
}