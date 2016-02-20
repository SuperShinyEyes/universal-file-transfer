//
//  ViewController.swift
//  universal-file-transfer
//
//  Created by YOUNG on 2/20/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import UIKit
import GCDWebServer
//#import "GCDWebServer.h"

class ViewController: UIViewController {
    
    let webServer = GCDWebServer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initWebServer()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initWebServer() {
        
        self.webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self, processBlock: {request in
            return GCDWebServerDataResponse(HTML:"<html><body><p>Hello World</p></body></html>")
            
        })
        self.webServer.startWithPort(8080, bonjourName: "GCD Web Server")
        
        print("Visit \(self.webServer.serverURL) in your web browser")
    }

}

