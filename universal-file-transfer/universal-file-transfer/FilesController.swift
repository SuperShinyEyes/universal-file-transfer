//
//  FilesController.swift
//  universal-file-transfer
//
//  Created by YOUNG on 4/16/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation
import UIKit
import GCDWebServer
import EmitterKit
import Alamofire
import AlamofireImage

class FilesController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    var fileArray = [DownloadableItem]()
    let operationQueue = NSOperationQueue.mainQueue()
    var itemListener:Listener?
    @IBOutlet var fileTableView: UITableView!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.itemListener = GeneralHelperInstance.newItemFoundEvent.on { (let item) -> Void in
            self.addItem(item)
        }
        
        self.operationQueue.maxConcurrentOperationCount = 1
        // Do any additional setup after loading the view, typically from a nib.
        self.fileTableView.delegate = self
        self.fileTableView.dataSource = self
        self.refreshItemList()
        
    }
    

    func refreshItemList() {
        self.operationQueue.addOperationWithBlock { () -> Void in
            self.fileArray = GeneralHelperInstance.downloadableItems
            self.fileTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func addItem(item: DownloadableItem){
        self.operationQueue.addOperationWithBlock { () -> Void in
                self.fileArray.append(item)
                self.fileTableView.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.fileArray[indexPath.row]
        self.performSegueWithIdentifier("toImageScreen", sender: item)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        
        UITableViewCell {
            let cell =  self.fileTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DeviceCell
            
            cell.deviceName.text = fileArray[indexPath.row].path
            return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let imageController = segue.destinationViewController as? ImageController, let item = sender as? DownloadableItem {
            imageController.item = item
        }
    }
    
}

