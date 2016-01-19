//
//  CameraViewController.swift
//  Reacture
//
//  Created by Ben Patch & Andrew Porter on 1/5/16. Amended by Eric Mead & Paul Adams on 1/14/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit
import AVFoundation

var hasTakenFirstPicture: Bool?

// A Delay Function

func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class RCT_CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapToFocusRecognizer = UITapGestureRecognizer(target: self, action: "tapToFocus:")
        setupCamera()
        setupButtons()
        
        focusBox = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        focusBox.backgroundColor = UIColor.clearColor()
        focusBox.layer.borderWidth = 1.0
        focusBox.layer.borderColor = UIColor.yellowColor().CGColor
        focusBox.alpha = 0.0
        view.addSubview(focusBox)
    }
    
    override func viewWillAppear(animated: Bool) {
        hasTakenFirstPicture = false
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Variables

    // Bool for Switching Previews
    var backCameraIsPreview: Bool = true
    var rCTImage: RCT_Image? = nil
    var captureSesson = AVCaptureSession()
    var frontInput: AVCaptureDeviceInput?
    var backInput: AVCaptureDeviceInput?
    var frontCaptureDevice: AVCaptureDevice?
    var backCaptureDevice: AVCaptureDevice?
    var currentCaptureDevice: AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    let previewView = UIView()
    var previewLayer = AVCaptureVideoPreviewLayer()

    // Flash Variables
    let flashView = UIView()
    let currentBrightness = UIScreen.mainScreen().brightness

    // Image Variables
    var frontImage = UIImage()
    var backImage = UIImage()
    
    // Tap to focus variables
    var tapToFocusRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var previewPointOfTap = CGPoint()
    var captureDevicePointOfTap = CGPoint()
    var focusBox = UIView()

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
                    iSightFlashButton.alpha = 1
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

        // Flash Screen
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

                        //TODO: - Possibly Add KVO

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
                        }) // End of Delay Closure
                    }
                })
            }
        } else {
            //Front Camera Should Already Be on Preview Layer
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

                        //TODO: - Possibly Add KVO

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
                        }) // End of Delay Closure
                    }
                })
            }
        }
    }

    @IBAction func switchCameraButtonTapped(sender: AnyObject) {
        print("Camera Switched")
        if self.backCameraIsPreview == true {
            // Back is Preview, Switching to Front
            UIView.transitionWithView(self.previewView, duration: 0.5, options: [UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.TransitionFlipFromRight], animations: { () -> Void in
                //self.previewView.hidden = true
                 print("Animating Flip Preview to Front")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.previewView.alpha = 0
                })
                }, completion: {_ in
                    self.previewView.hidden = false
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.previewView.alpha = 1
                    })
            })
            delay(seconds: 0.1, completion: { () -> () in
                print("Switching to Front Preview")
                self.captureSesson.beginConfiguration()
                self.captureSesson.removeInput(self.backInput)
                self.captureSesson.addInput(self.frontInput)
                self.captureSesson.commitConfiguration()
                self.backCameraIsPreview = false
            })

        } else {

            // Front is Preview, Switching to Back
            print("Switching to Back Preview")
            UIView.transitionWithView(self.previewView, duration: 0.5, options: [UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.TransitionFlipFromRight], animations: { () -> Void in
                self.previewView.hidden = true
                print("Animating Flip Preview to Front")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.previewView.alpha = 0
                })
                }, completion: {_ in
                    self.previewView.hidden = false
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.previewView.alpha = 1
                    })
            })
            delay(seconds: 0.1, completion: { () -> () in
                self.captureSesson.beginConfiguration()
                self.captureSesson.removeInput(self.frontInput)
                self.captureSesson.addInput(self.backInput)
                self.captureSesson.commitConfiguration()
                self.backCameraIsPreview = true
            })
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
                print("Connection Established")
                
                var orientation: AVCaptureVideoOrientation
                switch UIDevice.currentDevice().orientation {
                case .Portrait:
                    orientation = .Portrait
                case .PortraitUpsideDown:
                    orientation = .PortraitUpsideDown
                case .LandscapeLeft:
                    orientation = .LandscapeRight
                case .LandscapeRight:
                    orientation = .LandscapeLeft
                default:
                    orientation = .Portrait
                }
                connection.videoOrientation = orientation

                var soundID: SystemSoundID = 0;
                if (hasTakenFirstPicture!) {
                    hasTakenFirstPicture = false
                } else {
                    if (soundID == 0) {
                        let path = NSBundle.mainBundle().pathForResource("photoShutter2", ofType: "caf")
                        let filePath = NSURL(fileURLWithPath: path!, isDirectory: false) as CFURLRef
                        AudioServicesCreateSystemSoundID(filePath, &soundID);
                    }
                    AudioServicesPlaySystemSound(soundID)
                    hasTakenFirstPicture = true
                }
                
                 // TODO: Change Code to Allow Landscape
                
                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (cmSampleBuffer, error) -> Void in
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(cmSampleBuffer) {
                        completion(data: imageData)
                    }
                })
            }
        }
    }

    override func viewDidDisappear(animated: Bool) {
        self.previewView.layer.addSublayer(self.previewLayer)
        self.view.bringSubviewToFront(self.shutterButton)
        self.view.bringSubviewToFront(self.switchCameraButton)
        self.view.bringSubviewToFront(iSightFlashButton)
    }

    func setDarkBackground() {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let darkView = UIView()
        darkView.frame = rect
        darkView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(darkView)
    }
    
    // Focus Box
    func focusBox(centerPoint: CGPoint) {
        
        focusBox.center = centerPoint
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            
            self.focusBox.alpha = 1.0
            }) { (_) -> Void in
                self.focusBox.alpha = 0.0
        }
    }

    func frontFlash() {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        flashView.frame = rect
//        flashView.backgroundColor = UIColor(red: 1, green: 0.718, blue: 0.318, alpha: 0.75)
        flashView.backgroundColor = UIColor.whiteColor()
        flashView.alpha = 1.0
        self.view.addSubview(flashView)
        delay(seconds: 0.1) { () -> () in
            UIScreen.mainScreen().brightness = 1.0
        }
    }
    
    // MARK: - Tap to Focus
    // setup tap gesture recognizer
    func tapToFocus(recognizer: UIGestureRecognizer) {
        
        previewPointOfTap = recognizer.locationInView(self.view)
        focusBox(previewPointOfTap)
        captureDevicePointOfTap = previewLayer.captureDevicePointOfInterestForPoint(previewPointOfTap)
        
        if let focusDevice = currentCaptureDevice  {
            if focusDevice.focusPointOfInterestSupported {
                do {
                    try focusDevice.lockForConfiguration()
                    focusDevice.focusPointOfInterest = captureDevicePointOfTap
                    if focusDevice.isFocusModeSupported(.AutoFocus) {
                        focusDevice.focusMode = .AutoFocus
                    }
                    focusDevice.unlockForConfiguration()
                    print("Point in capture device: \(previewLayer.captureDevicePointOfInterestForPoint(captureDevicePointOfTap))")
                    
                } catch {
                    error
                    print("Lock for configuration unsuccessful \(error)")
                }
            }
        }
        
        print("Focus mode: \(currentCaptureDevice!.focusMode.rawValue)")
        print("Point in previewView: \(previewPointOfTap)")
    }
    
    func focusAreaBox(recognizer: UIGestureRecognizer) {
        
        
    }
    
    // MARK: - Setup UI

    func setupButtons() {
        let width = self.view.frame.width / 6
        // Shutter Button
        shutterButton.frame.size = CGSize(width: width, height: width)
        shutterButton.center.x = self.view.center.x
        shutterButton.frame.origin.y = self.view.frame.size.height - shutterButton.frame.size.height - 10
        shutterButton.layer.borderColor = UIColor.whiteColor().CGColor
        flashView.backgroundColor = UIColor(red: 1, green: 0.718, blue: 0.318, alpha: 0.75)
        shutterButton.layer.borderWidth = 3
        shutterButton.layer.cornerRadius = width / 2
        shutterButton.backgroundColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1) // Hex #F85927
        shutterButton.layer.opacity = 0.5
        shutterButton.addTarget(self, action: "shutterButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(shutterButton)
        // iSight Flash Button
        iSightFlashButton.frame.size = CGSize(width: 25, height: 44)
        iSightFlashButton.frame.origin.x = 20
        iSightFlashButton.frame.origin.y = 8
        iSightFlashButton.setBackgroundImage(UIImage(named: "iSightFlashButton_Off")!, forState: .Normal)
        iSightFlashButton.imageView?.contentMode = .ScaleAspectFit
        iSightFlashButton.alpha = 1
        iSightFlashButton.addTarget(self, action: "iSightFlashButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(iSightFlashButton)
        // Switch Camera Button
        switchCameraButton.alpha = 1
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

    // MARK: - Setting up Camera

    func setupCamera() {

        print("Setting Up Camera")
        self.captureSesson.sessionPreset = AVCaptureSessionPresetPhoto
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]

        let devices = AVCaptureDevice.devices()

        print(devices.count)

        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    backCaptureDevice = device as? AVCaptureDevice
                    print("Has Back Camera")
                }
                if (device.position == AVCaptureDevicePosition.Front) {
                    frontCaptureDevice = device as? AVCaptureDevice
                    print("Has Front Camera")
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
                    self.currentCaptureDevice = backCamera
                    print("Back Camera Input was Added")

                    if captureSesson.canAddOutput(stillImageOutput) {
                        captureSesson.addOutput(stillImageOutput)
                        print("Back Camera Output was Added")
                        setupPreview()
                        captureSesson.startRunning()
                        print("Session has Started")
                    }
                }
            } catch {
                error
                print("Error Getting Input from Back")
            }
        }
    }

    func getFrontInput() {
        
        if let frontCamera = frontCaptureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: frontCamera)
                self.frontInput = input
                self.currentCaptureDevice = frontCamera
            } catch {
                error
            }
        }
    }

    func setupPreview() {
        
        // Setting size of preview
        previewView.frame = self.view.frame
        previewView.center.x = self.view.center.x
        self.view.addSubview(previewView)
        self.view.bringSubviewToFront(previewView)
        print("Setting up preview")
        previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSesson)
        
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        print("\(previewLayer.frame.size)")
        previewView.layer.addSublayer(self.previewLayer)
        previewLayer.frame = self.previewView.frame
        previewView.addGestureRecognizer(tapToFocusRecognizer)
        
        self.view.bringSubviewToFront(shutterButton)
        self.view.bringSubviewToFront(switchCameraButton)
        self.view.bringSubviewToFront(iSightFlashButton)
        //print("PreviewLayer: \(previewLayer.bounds.size) PreviewView: \(previewView.bounds.size)")
    }
    
    func flipPreviewLayer(animationOption: UIViewAnimationOptions) {
        UIView.transitionWithView(self.previewView, duration: 1, options: [UIViewAnimationOptions.CurveEaseInOut, animationOption], animations: { () -> Void in
            self.previewView.hidden = false
            }, completion: {_ in
        })
    }
}