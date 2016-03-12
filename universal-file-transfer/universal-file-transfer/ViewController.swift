//
//  ViewController.swift
//  universal-file-transfer
//
//  Created by YOUNG on 2/20/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import UIKit
import GCDWebServer
import EmitterKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    var deviceArray:[Device] = []
    let operationQueue = NSOperationQueue.mainQueue()
    var deviceListener: Listener?
    let imagePicker = UIImagePickerController()
    @IBOutlet var deviceTableView: UITableView!

    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
        
        
       
                   // self.addItem("asDasdasf2")

    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.operationQueue.maxConcurrentOperationCount = 1
        // Do any additional setup after loading the view, typically from a nib.
        self.deviceTableView.delegate = self
        self.deviceTableView.dataSource = self


        self.imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBAction func startServingFiles(sender: AnyObject) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
        
        GeneralHelper.getServer().startGivingImage(image)
    }
    
    func addItem(device: Device){
        self.operationQueue.addOperationWithBlock { () -> Void in
            let isAlreadyIn = self.deviceArray.contains({ (let deviceInArray) -> Bool in

                return device.getName() == deviceInArray.getName()
            })
            if(!isAlreadyIn){
                self.deviceArray.append(device)
                self.deviceTableView.reloadData()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        
        UITableViewCell {
            let cell =  self.deviceTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DeviceCell
            
            cell.deviceName.text = deviceArray[indexPath.row].getName()
            return cell
    }
    

    
}

