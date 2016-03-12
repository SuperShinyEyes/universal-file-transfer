//
//  Device.swift
//  universal-file-transfer
//
//  Created by AllConnect Student on 12/03/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation

class Device:NSObject {
    override init(){
        super.init()
    }
    
    var name: String?
    var ip: String?
    
    func setDeviceName(nameToSet: String){
        self.name = nameToSet
    }
    
    func getName() -> String{
        return self.name!
    }
    func get() -> String{
        return self.ip!
    }
}