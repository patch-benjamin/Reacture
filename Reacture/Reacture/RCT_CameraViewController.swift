//
//  CameraViewController.swift
//  FlipPic
//
//  Created by Ben Patch & Andrew Porter on 1/5/16. Amended by Eric Mead & Paul Adams on 1/14/16. Amended by Skyler Tanner on 1/16/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import UIKit
import AVFoundation

var hasTakenFirstPicture: Bool?
var soundID: SystemSoundID = 0

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

        let path = NSBundle.mainBundle().pathForResource("photoShutter2", ofType: "caf")
        let filePath = NSURL(fileURLWithPath: path!, isDirectory: false) as CFURLRef
        AudioServicesCreateSystemSoundID(filePath, &soundID)

        // Initialize the Focal Box and Set Alpha Level to 0.0
        focusBox = UIView(frame: CGRect(x: 0.0, y: 0.0, width: focusBoxSize, height: focusBoxSize))
        focusBox.backgroundColor = UIColor.clearColor()
        focusBox.layer.borderWidth = 1.0
        focusBox.layer.cornerRadius = CGFloat(focusBoxSize/2)
        focusBox.layer.borderColor = UIColor.whiteColor().CGColor
        focusBox.alpha = 0.0
        focusBoxInner = UIView(frame: CGRect(x: 0.0, y: 0.0, width: focusBoxSize, height: focusBoxSize))
        focusBoxInner.center = CGPoint(x: focusBox.bounds.maxX/2, y: focusBox.bounds.maxY/2)
        focusBoxInner.layer.cornerRadius = CGFloat((focusBoxSize - 2)/2)
        focusBoxInner.backgroundColor = UIColor.clearColor()
        focusBoxInner.alpha = 0.0
        view.addSubview(focusBox)
        focusBox.addSubview(focusBoxInner)

    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (hasTakenFirstPicture!) {
            hasTakenFirstPicture = false
        } else {
            AudioServicesPlaySystemSound(soundID)
            hasTakenFirstPicture = true
        }
    }

    override func viewWillAppear(animated: Bool) {
        hasTakenFirstPicture = false
        self.stillImageOutput.addObserver(self, forKeyPath: "capturingStillImage", options: [NSKeyValueObservingOptions.New], context: nil)
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
    var focusBoxInner = UIView()
    var focusBoxSize = 65.0

    // Session Queue
    let sessionQueue = dispatch_queue_create("io.flippic.cameraCapture", DISPATCH_QUEUE_SERIAL)

    // MARK: - Outlets

    @IBOutlet weak var switchCameraButton: UIButton!

    // MARK: - Buttons

    let shutterButton = UIButton()
    let iSightFlashButton = UIButton()
    let shutterButtonBorder: UIView = UIView()
    
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

                        // TODO: - Possibly Add KVO

                        delay(seconds: 0.1, completion: { () -> () in
                            if let frontCamera = self.frontCaptureDevice {
                                self.takePic(frontCamera, session: self.captureSesson, completion: { (data) -> Void in
                                    if let frontData = data {
                                        self.frontImage = UIImage(data: frontData)!
                                        print("Front Camera Data is Here")
                                        let layout = Layout(rawValue: 0)!
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

                        // TODO: - Possibly Add KVO

                        delay(seconds: 0.1, completion: { () -> () in
                            if let backCamera = self.backCaptureDevice {
                                self.takePic(backCamera, session: self.captureSesson, completion: { (data) -> Void in
                                    if let backData = data {
                                        self.backImage = UIImage(data: backData)!
                                        print("Back Camera Data is Here")
                                        let layout = Layout(rawValue: 0)!
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

                // TODO: Change Code to Allow Landscape

                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (cmSampleBuffer, error) -> Void in
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(cmSampleBuffer) {
                        completion(data: imageData)
                    }
                })
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.stillImageOutput.removeObserver(self, forKeyPath: "capturingStillImage")
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

    // Focus Box Animation
    func focusBox(centerPoint: CGPoint) {

        let focusBoxScaleTransform = CGAffineTransformMakeScale(0.75, 0.75)
        let focusBoxScaleTransformShrink = CGAffineTransformMakeScale(0.77, 0.77)
        focusBox.center = centerPoint
        focusBox.bounds.size = CGSize(width: self.focusBoxSize, height: self.focusBoxSize)
        focusBoxInner.bounds.size = CGSize(width: self.focusBoxSize, height: self.focusBoxSize)
        focusBox.alpha = 1.0
        focusBoxInner.backgroundColor = UIColor.whiteColor()


        UIView.animateWithDuration(0.5, animations: { () -> Void in

            self.focusBox.alpha = 1.0
            self.focusBoxInner.alpha = 0.4
            self.focusBox.transform = focusBoxScaleTransform
            //            self.focusBoxInner.transform = focusBoxScaleTransform

            }) { (_) -> Void in

                UIView.animateWithDuration(0.5, animations: { () -> Void in

                    self.focusBox.transform = focusBoxScaleTransformShrink
                    self.focusBox.alpha = 0.0
                    self.focusBoxInner.alpha = 0.0

                    }) { (_) -> Void in

                }
        }
    }

    func frontFlash() {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        flashView.frame = rect
        flashView.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 0.7176, blue: 0.47, alpha: 1.0)
        flashView.alpha = 1.0
        self.view.addSubview(flashView)
        delay(seconds: 0.3) { () -> () in
            UIScreen.mainScreen().brightness = 1.0
        }
    }

    // MARK: - Tap to Focus
    // Setup Tap Gesture Recognizer
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
                    print("Point in Capture Device: \(previewLayer.captureDevicePointOfInterestForPoint(captureDevicePointOfTap))")

                } catch {
                    error
                    print("Lock for Configuration Unsuccessful \(error)")
                }
            }
        }

        print("Focus Mode: \(currentCaptureDevice!.focusMode.rawValue)")
        print("Point in previewView: \(previewPointOfTap)")
    }

    func focusAreaBox(recognizer: UIGestureRecognizer) {


    }

    // MARK: - Setup UI

    func setupButtons() {
        let width = self.view.frame.width / 6
        let borderWidth: CGFloat = (self.view.frame.width + 3)/6
        // Shutter Button
        
        shutterButton.frame.size = CGSize(width: width, height: width)
        shutterButtonBorder.frame.size = CGSize(width: borderWidth, height: borderWidth)
        shutterButtonBorder.center.x = self.view.center.x
        shutterButton.center = CGPoint(x: shutterButtonBorder.bounds.maxX/2, y: shutterButtonBorder.bounds.maxY/2)
        shutterButtonBorder.frame.origin.y = self.view.frame.size.height - shutterButton.frame.size.height - 10
        flashView.backgroundColor = UIColor(red: 1, green: 0.718, blue: 0.318, alpha: 0.75)
        shutterButton.layer.cornerRadius = width / 2
        shutterButtonBorder.layer.cornerRadius = borderWidth/2
        shutterButton.backgroundColor = UIColor.whiteColor()
        shutterButton.alpha = 0.5
        shutterButtonBorder.backgroundColor = UIColor.clearColor()
        shutterButtonBorder.layer.borderWidth = 3
        shutterButtonBorder.layer.borderColor = UIColor.whiteColor().CGColor
        shutterButton.addTarget(self, action: "shutterButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(shutterButtonBorder)
        shutterButtonBorder.addSubview(shutterButton)
        shutterButton.sendSubviewToBack(shutterButtonBorder)
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
        AudioServicesPlaySystemSound(soundID)
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
        print("Setting up Preview")
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