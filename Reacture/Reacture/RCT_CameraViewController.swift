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

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: -  Variables

    // Bool for switching previews
    var backCameraIsPreview: Bool = true

    var rCTImage: RCT_Image? = nil
    var captureSesson = AVCaptureSession()
    var frontInput: AVCaptureDeviceInput?
    var backInput: AVCaptureDeviceInput?
    var frontCaptureDevice: AVCaptureDevice?
    var backCaptureDevice: AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()

    // Flash Variables
    let flashView = UIView()
    let currentBrightness = UIScreen.mainScreen().brightness

    // Image Variables
    var frontImage = UIImage()
    var backImage = UIImage()

    // Session Queue
    let sessionQueue = dispatch_queue_create("com.reacture.cameraCapture", DISPATCH_QUEUE_SERIAL)

    // MARK: - Outlets

    @IBOutlet weak var switchCameraButton: UIButton!

    // MARK: - Buttons
    let shutterButton = UIButton()
    let iSightFlashButton = UIButton()

    // MARK: - Actions

    @IBAction func iSightFlashButtonTapped(sender: AnyObject) {
        print("iSight Flash Button Tapped")
        if let device = self.backCaptureDevice {
            if device.hasFlash == true {
                do {
                    let iSightFlashConfiguration = try device.lockForConfiguration()
                } catch {
                    print("Error: iSight Flash Button Tapped")
                }
                if device.flashActive == true {
                    print("Turning Off iSight Flash")
                    device.flashMode = AVCaptureFlashMode.Off
                    iSightFlashButton.setBackgroundImage(UIImage(named: "iSightFlashButton_Off")!, forState: .Normal)
                    iSightFlashButton.alpha = 0.8
                } else {
                    print("Turning On iSight Flash")
                    device.flashMode = AVCaptureFlashMode.On
                    iSightFlashButton.setBackgroundImage(UIImage(named: "iSightFlashButton_On")!, forState: .Normal)
                    iSightFlashButton.alpha = 1
                }
                device.unlockForConfiguration()
            }
        }
    }

    @IBAction func shutterButtonTapped(sender: AnyObject) {

        print("Shutter Button Tapped")

        self.previewLayer.removeFromSuperlayer()
        //setDarkBackground()

        // Flash screen
        self.frontFlash()

        if backCameraIsPreview == true {

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
                                        print("Front Camera Data is Here")
                                        let layout = Layout.TopBottom
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
        } else {
            //Front camera should be on preview layer already
            if let frontCamera = frontCaptureDevice {
                takePic(frontCamera, session: captureSesson, completion: { (data) -> Void in
                    if let frontData = data {
                        print("Front Camera Data is Here")
                        // TODO: - Refactor
                        self.frontImage = UIImage(data: frontData)!
                        self.captureSesson.beginConfiguration()
                        self.captureSesson.removeInput(self.frontInput)
                        self.captureSesson.addInput(self.backInput)
                        self.captureSesson.commitConfiguration()

                        //TODO: - possibly add KVO

                        delay(seconds: 0.1, completion: { () -> () in
                            if let backCamera = self.backCaptureDevice {
                                self.takePic(backCamera, session: self.captureSesson, completion: { (data) -> Void in
                                    if let backData = data {
                                        self.backImage = UIImage(data: backData)!
                                        print("Back Camera Data is Here")

                                        let layout = Layout.TopBottom

                                        self.rCTImage = RCT_ImageController.createRCTImageFromImages(self.frontImage, imageBack: self.backImage, layout: layout)
                                        self.performSegueWithIdentifier("ToEditView", sender: self)
                                        self.captureSesson.beginConfiguration()
                                        // This is questionable if we need to do this switch
                                        self.captureSesson.removeInput(self.backInput)
                                        self.captureSesson.addInput(self.frontInput)
                                        self.captureSesson.commitConfiguration()
                                    }
                                })
                            }
                        }) // End of delay closure
                    }
                })
            }
        }
    }

    @IBAction func switchCameraButtonTapped(sender: AnyObject) {

        print("Camera Switched")

        if backCameraIsPreview == true {

            //back is preview, switching to front
            print("switching to front preview")
            self.captureSesson.beginConfiguration()

            // This is questionable if we need to do this switch
            self.captureSesson.removeInput(self.backInput)
            self.captureSesson.addInput(self.frontInput)
            self.captureSesson.commitConfiguration()
            backCameraIsPreview = false
        } else {
            // Front is Preview, Switching to Back
            print("switching to back preview")
            self.captureSesson.beginConfiguration()
            // This is questionable if we need to do this switch
            self.captureSesson.removeInput(self.frontInput)
            self.captureSesson.addInput(self.backInput)
            self.captureSesson.commitConfiguration()
            backCameraIsPreview = true
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
        self.view.bringSubviewToFront(self.switchCameraButton)
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

        flashView.frame = rect
        //flashView.backgroundColor = UIColor(red: 1, green: 0.718, blue: 0.318, alpha: 0.75)
        flashView.backgroundColor = UIColor.whiteColor()
        flashView.alpha = 1.0
        self.view.addSubview(flashView)
        delay(seconds: 0.1) { () -> () in
            UIScreen.mainScreen().brightness = 1.0
        }
    }

    // MARK: - Setup UI

    func setupButtons() {
        let width = self.view.frame.width / 6
        // Shutter Button
        shutterButton.frame.size = CGSize(width: width, height: width)
        shutterButton.center.x = self.view.center.x
        shutterButton.frame.origin.y = self.view.frame.size.height - shutterButton.frame.size.height - 10
        shutterButton.layer.borderColor = UIColor.whiteColor().CGColor
        shutterButton.layer.borderWidth = 2
        shutterButton.layer.cornerRadius = width / 2
        shutterButton.backgroundColor = UIColor.redColor()
        shutterButton.addTarget(self, action: "shutterButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(shutterButton)
        // iSight Flash Button
        iSightFlashButton.frame.size = CGSize(width: 40, height: 40)
        iSightFlashButton.frame.origin.x = 7
        iSightFlashButton.frame.origin.y = 10
        iSightFlashButton.setBackgroundImage(UIImage(named: "iSightFlashButton_Off")!, forState: .Normal)
        iSightFlashButton.imageView?.contentMode = .ScaleAspectFit
        iSightFlashButton.alpha = 0.8
        iSightFlashButton.addTarget(self, action: "iSightFlashButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(iSightFlashButton)
        // Switch Camera Button
        switchCameraButton.alpha = 0.9
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        UIView.animateWithDuration(3, animations: { () -> Void in

            UIScreen.mainScreen().brightness = self.currentBrightness
            self.flashView.alpha = 0

            }, completion: { _ in
                self.flashView.alpha = 1
                self.flashView.removeFromSuperview()

        })

        if segue.identifier == "ToEditView" {

            let editVC = segue.destinationViewController as! RCT_EditViewController
            
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
        
        self.view.bringSubviewToFront(switchCameraButton)
        
        self.view.bringSubviewToFront(iSightFlashButton)
        
    }
}