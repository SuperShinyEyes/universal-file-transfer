//
//  GeneralHelper.swift
//  universal-file-transfer
//
//  Created by YOUNG on 2/20/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation
import UIKit

public struct GeneralHelper {
    
    static private func getAppDelegate() -> AppDelegate {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate
    }
    
    static public func getServer() -> ServerController {
        return getAppDelegate().server
    }
    
    public enum KeyError: ErrorType {
        case NoKey
    }
    
    static public func getData(dict: [String:UIImage], key: String) throws -> UIImage {
        guard let image = dict[key] else {
            throw KeyError.NoKey
        }
        return image
    }
}