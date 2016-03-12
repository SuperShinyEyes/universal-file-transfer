//
//  UDPsocket.swift
//  universal-file-transfer
//
//  Created by YOUNG on 3/12/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

//From Android side
//port = 3003
//multicastGroup = "239.1.1.1"
/*
Use CocoaAsyncSocket for multicasting in order to select other devices.

*/
class UDPsocket:GCDAsyncUdpSocketDelegate {
    
    static let sharedInstance = UDPsocket()
    static let ipAddress = "239.1.1.1"
    static let port: UInt16 = 3003

    private init(){
    
        self.socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        self.startBindToPort()
        self.startJoinMulticastGroup()
//        self.startEnableBroadcast()
        self.startBeginReceiving()

//        self.connectTo(self.dynamicType.ipAddress, port: self.dynamicType.port)
        
//        self.socket.joinMulticastGroup(self.dynamicType.ipAddress)
//        self.startJoinMulticastGroup()
//        self.startEnableBroadcast()
//        self.startBeginReceiving()

    }
    
    func startJoinMulticastGroup(){
        do {
            try self.socket.joinMulticastGroup(self.dynamicType.ipAddress)
        } catch let error as NSError {
            NSLog("Failed to join MulticastGroup: \(error)")
        }catch {
            NSLog("Failed to join MulticastGroup")
            
        }
    }
    
    func startBeginReceiving(){
        do {
            try self.socket.beginReceiving()
        } catch {
            NSLog("Failed to receive")
        }
    }
    
    func startBindToPort(){
        do {
            try self.socket.bindToPort(self.dynamicType.port)
        } catch {
            NSLog("Failed to bind to port")
        }
    }
    
    func startEnableBroadcast(){
        do {
            try self.socket.enableBroadcast(true)
        } catch {
            NSLog("Failed to enable Broadcast")
        }
        
    }
    
    func connectTo(ipAddress: String, port: UInt16) {
        do {
            try self.socket.connectToHost(ipAddress, onPort: port)
        } catch {
            NSLog("Failed to connect to \(ipAddress) port# @ \(port)")
        }

    }
    
    var socket: GCDAsyncUdpSocket!
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        let byteArray = self.getByteArrayFromNSData(address)
        NSLog("Connect to \(byteArray)")
    }
    
    func startLookingForDevices(){
        self.sendData(0x01, dataLength: 1)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        switch tag {
        case 1:
            NSLog("We sent a message for searching devices")
            
        default:
            break
        }
    }
    
    func sendData(signal: UInt8, dataLength: Int) {
        let data = NSData(bytes: [signal] as [UInt8], length: dataLength)
        self.socket.sendData(data, toHost: self.dynamicType.ipAddress, port: self.dynamicType.port, withTimeout: 2.0, tag: 1)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        NSLog("Received \(data)")
        let dataArray = self.getByteArrayFromNSData(data)
//        let senderAddress = self.getByteArrayFromNSData(address)
        if let firstNumber = dataArray.first where dataArray.count == 1 {
            if (firstNumber == 1) {
                self.sendData(0x00, dataLength: 1)
            }
        }
    }
    
    func getByteArrayFromNSData(data: NSData) -> [UInt8] {
        var byteArray = [UInt8](count: data.length, repeatedValue: 0x00)
        data.getBytes(&byteArray, length: data.length)
        return byteArray
    }
    

//    func test() {
//        self.socket
//    }
    
}