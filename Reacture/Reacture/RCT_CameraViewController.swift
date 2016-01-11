//
//  CameraViewController.swift
//  Reacture
//
//  Created by Ben Patch on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit
import AVFoundation

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


    // MARK: Variables

    var rCTImage: RCT_Image? = nil
    
    //Buttons
    let shutterButton = UIButton()
    
    var captureSesson = AVCaptureSession()
    var frontCaptureDevice: AVCaptureDevice?
    var backCaptureDevice: AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()

    // MARK: Functions

    func setMockImage() {

        let frontImage = UIImage(named: "mock_selfie")
        let backImage = UIImage(named: "mock_landscape")

        let frontImageData = RCT_ImageController.imageToData(frontImage!)!
        let backImageData = RCT_ImageController.imageToData(backImage!)!

        self.rCTImage = RCT_ImageController.createRCTImage(frontImageData, imageBack: backImageData)

    }

    // MARK: Outlets
    

    // MARK: Actions

    @IBAction func shutterButtonTapped(sender: AnyObject) {
    
        print("Shutter Button Tapped")
        
        RCT_CameraController.takeRCTImage { (rCTImage) -> Void in
            // Do Something
        }
        
        setMockImage()
        performSegueWithIdentifier("ToEditView", sender: self)
    }
    
    @IBAction func switchCameraButtonTapped(sender: AnyObject) {
        
        print("test: Camera Switched")
        
        RCT_CameraController.switchCamera { () -> Void in
            
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
                }
            }
        }
        
        if let backCamera = backCaptureDevice {
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                if self.captureSesson.canAddInput(input) {
                    self.captureSesson.addInput(input)
                    captureSesson.addOutput(stillImageOutput)
                    
                    setupPreview()
                    captureSesson.startRunning()
                    print("Session has started")
                }
            } catch {
                error
                print("error getting input from back")
            }
            
        }
        
        
    }
    
    func setupPreview() {
        
        let previewView = UIView()
        
        // Setting size of preview
        previewView.frame = self.view.frame
        self.view.addSubview(previewView)
        self.view.bringSubviewToFront(previewView)
        
        
        print("Setting up priview")
        previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSesson)
        previewView.layer.addSublayer(self.previewLayer)
        previewLayer.frame = self.view.layer.frame
    }
}