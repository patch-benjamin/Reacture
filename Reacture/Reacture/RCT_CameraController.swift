//
//  CameraController.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/6/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import Foundation


class RCT_CameraController {
    
    static func setupCamera(completion: () -> Void) {
        
        print("test: Camera setup.")
        completion()

    }
    
    static func takeFrontPicture(completion: (imageData: NSData) -> Void) {
        
        print("test: Front picture taken")
        completion(imageData: NSData())
        
    }
    
    static func takeBackPicture(completion: (imageData: NSData) -> Void) {
    
        print("test: Back picture taken")
        completion(imageData: NSData())
    
    }
    
    static func takeRCTImage(completion: (rCTImage: RCT_Image?) -> Void) { // TODO: REMOVE optional value of RCT_Image?
        
        // call take front picture
        // call take back picture (in correct order...)

        print("test: RCTImage taken")
        completion(rCTImage: nil)
        
    }
    
    static func switchCamera(completion: () -> Void) {
        completion()
    }

    static func setFlash(flashOn: Bool) {

    }

    // METHODS FOR ENABLING/DISABLING/SWITCHING THE PREVIEW???

    // METHODS FOR SET FOCUS????
    
}