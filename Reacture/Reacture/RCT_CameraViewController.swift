//
//  CameraViewController.swift
//  Reacture
//
//  Created by Ben Patch on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

class RCT_CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Variables

    var rCTImage: RCT_Image? = nil


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