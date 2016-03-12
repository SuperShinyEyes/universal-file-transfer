//
//  UDPsocket.swift
//  universal-file-transfer
//
//  Created by YOUNG on 3/12/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import EmitterKit

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
    var socket: GCDAsyncUdpSocket!
    var whiteList = [String]()
    let deviceFoundEvent = Event<Device>()

    private init(){
        // The order of socket communication initialization is IMPORTANT!!!

        self.socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        self.startBindToPort()
        self.startJoinMulticastGroup()
        self.startBeginReceiving()
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



    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        let byteArray = self.getByteArrayFromNSData(address)
        NSLog("Connect to \(byteArray)")
    }

    func startLookingForDevices(){
        // 0x01(1 in decimal) means "searching for other devices"
        self.sendData(0x01, dataLength: 1)
    }

    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        switch tag {
        case 1:
            NSLog("We sent a message for searching devices")
        case 0:
            NSLog("We sent a message for response to request")

        default:
            break
        }
    }

    func sendData(signal: UInt8, dataLength: Int) {
        // When multicasting it will send message from itself too
        let data = NSData(bytes: [signal] as [UInt8], length: dataLength)
        self.socket.sendData(data, toHost: self.dynamicType.ipAddress, port: self.dynamicType.port, withTimeout: 2.0, tag: 1)
    }
    
    func appendToWhiteList(ipAddress: String) {
        
    }
    
    func emitDeviceCreated() {
        
    }
    
    func createNewDevice(ipAddress: String) {
        let device = Device()
        device.setDeviceName(ipAddress)
        device.ip = ipAddress
        NSLog(">>> Create new device: \(ipAddress)")
        self.deviceFoundEvent.emit(device)
    }
    
    func convertArrayToString(ipArray: [UInt8]) -> String{
        let slice: Array<UInt8> = Array(ipArray[4..<8])
        let sliceString = slice.map { (let number) -> String in
            String(number)
        }
        return sliceString.joinWithSeparator(".")
    }

    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        // Callback function when you receive data

        let dataArray = self.getByteArrayFromNSData(data)
        let ipAddressAsArray = self.getByteArrayFromNSData(address)

        NSLog(">>>Received \(data)\t \(ipAddressAsArray)")
        if let firstNumber = dataArray.first where dataArray.count == 1 {
            // Respond only if the tag is 1
            if (firstNumber == 1 || firstNumber == 0) {
                let ipAddressAsString = self.convertArrayToString(ipAddressAsArray)
                self.createNewDevice(ipAddressAsString)
            }
            
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



}
