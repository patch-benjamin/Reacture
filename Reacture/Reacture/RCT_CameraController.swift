//
//  CameraController.swift
//  FlipPic
//
//  Created by Benjamin Patch on 1/6/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import Foundation
import AVFoundation

class RCT_CameraController {

    //////////////////////////////
    //Testing Ground
    //////////////////////////////

    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    let availableCameraDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)

    //////////////////////////////
    //Testing Ground
    //////////////////////////////

    static func setupCamera(completion: () -> Void) {
        print("TEST: Camera Setup")
        completion()
    }

    static func takeFrontPicture(completion: (imageData: NSData) -> Void) {
        print("TEST: Front Picture Taken")
        completion(imageData: NSData())
    }

    static func takeBackPicture(completion: (imageData: NSData) -> Void) {
        print("TEST: Back Picture Taken")
        completion(imageData: NSData())
    }

    static func takeRCTImage(completion: (rCTImage: RCT_Image?) -> Void) { // TODO: REMOVE optional value of RCT_Image?

        // Call Take Front Picture
        // Call Take Back Picture (in correct order...)

        print("TEST: RCTImage Taken")
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