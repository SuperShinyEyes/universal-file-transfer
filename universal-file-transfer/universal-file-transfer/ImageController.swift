//
//  ImageController.swift
//  universal-file-transfer
//
//  Created by Elias Mikkola on 16/04/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import UIKit

class ImageController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var item: DownloadableItem?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        item?.getRequestImage({ (let image) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.indicator.stopAnimating()
                self.imageView.image = image
                if(image == nil) {
                    let alert = UIAlertView(title: "Download failure", message: "Failed to download item: \(self.item?.path)", delegate: nil, cancelButtonTitle: "Cancel")
                    alert.show()
                }
            })
        })
    }
}