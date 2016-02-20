//
//  ServerController.swift
//  universal-file-transfer
//
//  Created by YOUNG on 2/20/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation
import GCDWebServer

public class ServerController {
    
    let webServer = GCDWebServer()
    var imageDictionary = [Int:UIImage]()
    /*
        Starts, listens, uploads, downloads, stops
    */
    
    func stop() {
        
    }
    
    func upload() {
        
    }
    
    
    public func startGivingImage(image:UIImage) {
        /*
           Upload image to a path localhost/image_key
*/
        let index = self.imageDictionary.count
        self.imageDictionary[index] = image
//        self.runServer()
    }
    
//    private func getImageAsNSData(index: Int)
    
    
    private func respondToRequest(request: GCDWebServerRequest, completionBlock: GCDWebServerCompletionBlock) {
        
        GCDWebServerDataResponse(data: <#T##NSData!#>, contentType: <#T##String!#>)
        let filePath = NSBundle.mainBundle().pathForResource("cat", ofType: "jpg")
        let response = GCDWebServerFileResponse(file: filePath)
        
        completionBlock(response)
    }
    
    init() {
//        self.runServer()
    }
    
    func runServer() {
        
//        self.webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self, processBlock: {request in
//            return GCDWebServerDataResponse(HTML:"<html><body><p>Hello World</p></body></html>")
//            
//        })
        
        self.webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self) { (let request, let completionBlock) -> Void in
            self.respondToRequest(request, completionBlock: completionBlock)
        }
        
        self.webServer.startWithPort(8080, bonjourName: "GCD Web Server")
        
        print("Visit \(self.webServer.serverURL) in your web browser")
    }

    
}