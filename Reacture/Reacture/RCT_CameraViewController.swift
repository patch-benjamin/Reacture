//
//  CameraViewController.swift
//  Reacture
//
//  Created by Skyler Tanner on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
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
        
        let frontImage = UIImage(named: "Selfie")
        let backImage = UIImage(named: "Landscape")
        
        let frontImageData = RCT_ImageController.imageToData(frontImage!)!
        let backImageData = RCT_ImageController.imageToData(backImage!)!
        
        self.rCTImage = RCT_ImageController.createRCTImage(frontImageData, imageBack: backImageData)
        
    }
    
    
    
    // MARK: Outlets
    
    
    
    
    
    // MARK: Actions
    
    @IBAction func shutterButtonTapped(sender: AnyObject) {
    
        setMockImage()
        performSegueWithIdentifier("ToEditView", sender: self)
    
    }
    
    
    
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ToEditView" {
            
            let editVC = segue.destinationViewController as! RCT_EditViewController

//            editVC.loadView()
//            
            editVC.setupController(self.rCTImage!)
            
        }
        
    }

}
