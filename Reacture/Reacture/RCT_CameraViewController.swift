//
//  CameraViewController.swift
//  Reacture
//
//  Created by Ben Patch on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit
import AVFoundation

// A delay function
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class RCT_CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        setupButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -  Variables
    
    var rCTImage: RCT_Image? = nil
    var captureSesson = AVCaptureSession()
    var frontInput: AVCaptureDeviceInput?
    var backInput: AVCaptureDeviceInput?
    var frontCaptureDevice: AVCaptureDevice?
    var backCaptureDevice: AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    // Image Variables
    var frontImage = UIImage()
    var backImage = UIImage()
    
    // Session Queue
    let sessionQueue = dispatch_queue_create("com.reacture.cameraCapture", DISPATCH_QUEUE_SERIAL)
    
    // MARK: - Outlets
    
    // MARK: - Buttons
    let shutterButton = UIButton()
    
    
    // MARK: - Actions
    
    @IBAction func shutterButtonTapped(sender: AnyObject) {
        
        print("Shutter Button Tapped")
        
        self.previewLayer.removeFromSuperlayer()
        setDarkBackground()
        
        delay(seconds: 0.01) { () -> () in
            
            // Flash screen
            self.frontFlash()
        }
        
        if let backCamera = backCaptureDevice {
            
            takePic(backCamera, session: captureSesson, completion: { (data) -> Void in
                if let backData = data {
                    
                    print("back camera data is here")
                    
                    // TODO: - Refactor
                    self.backImage = UIImage(data: backData)!
                    
                    self.captureSesson.beginConfiguration()
                    
                    self.captureSesson.removeInput(self.backInput)
                    self.captureSesson.addInput(self.frontInput)
                    
                    self.captureSesson.commitConfiguration()
                    
                    //TODO: - possibly add KVO
                    delay(seconds: 0.1, completion: { () -> () in
                        
                        if let frontCamera = self.frontCaptureDevice {
                            
                            self.takePic(frontCamera, session: self.captureSesson, completion: { (data) -> Void in
                                
                                if let frontData = data {
                                    
                                    self.frontImage = UIImage(data: frontData)!
                                    
                                    print("front camera data is here")
                                    
                                    let layout = Layout.topBottom
                                    
                                    self.rCTImage = RCT_ImageController.createRCTImageFromImages(self.frontImage, imageBack: self.backImage, layout: layout)
                                    self.performSegueWithIdentifier("ToEditView", sender: self)
                                    
                                    self.captureSesson.beginConfiguration()
                                    
                                    self.captureSesson.removeInput(self.frontInput)
                                    self.captureSesson.addInput(self.backInput)
                                    
                                    self.captureSesson.commitConfiguration()
                                }
                                
                            })
                        }
                    }) // End of delay closure
                    
                }
                
            })
            
        }
        
        RCT_CameraController.takeRCTImage { (rCTImage) -> Void in
            // Do Something
        }
    }
    
    @IBAction func switchCameraButtonTapped(sender: AnyObject) {
        
        print("test: Camera Switched")
        
        RCT_CameraController.switchCamera { () -> Void in
            
        }
        
    }
    
    // MARK: Functions
    
    func setMockImage() {
        
        let frontImage = UIImage(named: "mock_selfie")
        let backImage = UIImage(named: "mock_landscape")
        
        let frontImageData = RCT_ImageController.imageToData(frontImage!)!
        let backImageData = RCT_ImageController.imageToData(backImage!)!
        
        self.rCTImage = RCT_ImageController.createRCTImage(frontImageData, imageBack: backImageData)
        
    }
    
    func takePic(device: AVCaptureDevice, session: AVCaptureSession, completion: (data: NSData?) -> Void) {
        
        var data: NSData?
        
        
        dispatch_async(sessionQueue) { () -> Void in
            
            //session.sessionPreset = AVCaptureSessionPresetPhoto
            if let connection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
                
                print("connection established")
                connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
                
                //TODO: change code to allow landscape
                //                connection.videoOrientation = AVCaptureVideoOrientation.PortraitUpsideDown
                //                connection.video
                print(UIDevice.currentDevice().orientation.rawValue)
                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (cmSampleBuffer, error) -> Void in
                    
                    
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(cmSampleBuffer) {
                        completion(data: imageData)
                    }
                })
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        self.view.layer.addSublayer(self.previewLayer)
        self.view.bringSubviewToFront(self.shutterButton)
    }
    
    func setDarkBackground() {
        
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let darkView = UIView()
        
        darkView.frame = rect
        
        darkView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(darkView)
    }
    
    func frontFlash() {
        
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let flashView = UIView()
        let currentBrightness = UIScreen.mainScreen().brightness
        
        flashView.frame = rect
        flashView.backgroundColor = UIColor.whiteColor()
        flashView.alpha = 1.0
        self.view.addSubview(flashView)
        
        UIScreen.mainScreen().brightness = 1.0
        
        delay(seconds: 0.15) { () -> () in
            
            UIScreen.mainScreen().brightness = currentBrightness
            flashView.removeFromSuperview()
        }
    }
    
    // MARK: - Setup UI
    
    func setupButtons() {
        
        var width = self.view.frame.width / 6
        
        shutterButton.frame.size = CGSize(width: width, height: width)
        shutterButton.center.x = self.view.center.x
        shutterButton.frame.origin.y = self.view.frame.size.height - shutterButton.frame.size.height - 20
        shutterButton.layer.borderColor = UIColor.whiteColor().CGColor
        shutterButton.layer.borderWidth = 1
        shutterButton.layer.cornerRadius = width / 2
        shutterButton.backgroundColor = UIColor.blueColor()
        shutterButton.addTarget(self, action: "shutterButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(shutterButton)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ToEditView" {
            
            let editVC = segue.destinationViewController as! RCT_EditViewController
            
            //            editVC.loadView()
            //
            editVC.setupController(self.rCTImage!)
            
        }
    }
}

extension RCT_CameraViewController {
    
    // MARK: - Setting up camera
    
    func setupCamera() {
        
        print("Setting up Camera")
        var error: NSError?
        self.captureSesson.sessionPreset = AVCaptureSessionPresetPhoto
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        
        let devices = AVCaptureDevice.devices()
        
        print(devices.count)
        
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    backCaptureDevice = device as? AVCaptureDevice
                    print("has back camera")
                }
                if (device.position == AVCaptureDevicePosition.Front) {
                    frontCaptureDevice = device as? AVCaptureDevice
                    print("has front camera")
                    
                    getFrontInput()
                }
            }
        }
        
        if let backCamera = backCaptureDevice {
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                self.backInput = input
                
                if self.captureSesson.canAddInput(input) {
                    self.captureSesson.addInput(input)
                    print("back camera input was added")
                    
                    
                    if captureSesson.canAddOutput(stillImageOutput) {
                        
                        captureSesson.addOutput(stillImageOutput)
                        print("back camera output was added")
                        
                        
                        setupPreview()
                        captureSesson.startRunning()
                        print("Session has started")
                    }
                }
            } catch {
                error
                print("error getting input from back")
            }
            
        }
        
        
    }
    
    
    func getFrontInput() {
        
        if let frontCamera = frontCaptureDevice {
            
            do {
                
                let input = try AVCaptureDeviceInput(device: frontCamera)
                
                self.frontInput = input
                
            } catch {
                error
            }
        }
    }
    
    func setupPreview() {
        
        let previewView = UIView()
        
        // Setting size of preview
        previewView.frame = self.view.frame
        self.view.addSubview(previewView)
        self.view.bringSubviewToFront(previewView)
        
        
        print("Setting up preview")
        previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSesson)
        previewView.layer.addSublayer(self.previewLayer)
        previewLayer.frame = self.view.layer.frame
    }
}