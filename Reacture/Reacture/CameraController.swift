//
//  CameraController.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/6/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import Foundation


class CameraController {
    
    static func takeFrontPicture() -> NSData {
        
        print("test: Front picture taken")
        return NSData()
        
    }
    
    static func takeBackPicture() -> NSData {
    
        print("test: Back picture taken")
        return NSData()
    
    }
    
    static func takeRCTImage() -> RCT_Image? {
        // TODO: remove optional value of RCT_Image?
        
        // call take front picture
        // call take back picture (in correct order...)
        
        print("test: RCTImage taken")
        return nil
        
    }
    
    static func switchCamera() {
        
    }
    
    static func setFlash(flashOn: Bool) {
        
    }
    
    
    // METHODS FOR ENABLING/DISABLING/SWITCHING THE PREVIEW???
    
    
    // METHODS FOR SET FOCUS????

    
    
}