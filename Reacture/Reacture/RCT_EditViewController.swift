//
//  RCT_EditViewController.swift
//  Reacture
//
//  Created by Skyler Tanner on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

class RCT_EditViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let image1 = RCT_ImageController.dataToImage(self.rCTImage!.imageFront)!
        let image2 = RCT_ImageController.dataToImage(self.rCTImage!.imageBack)!
        //rCTImageView.backgroundColor = UIColor(patternImage: image)
        
        setUpImages(image1, back: image2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Variables
    //////////////////////////////
    //////////////////////////////
    
    var rCTImage: RCT_Image?
    
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Functions
    //////////////////////////////
    //////////////////////////////
    
    func setupController(rCTImage: RCT_Image) {
        
        self.rCTImage = rCTImage
    }
    
    func setUpImages(front: UIImage, back: UIImage){
        
        let image1View = UIImageView()
        image1View.frame.origin.x = self.view.frame.origin.x
        image1View.frame.size = CGSize(width: self.view.frame.width / CGFloat(2) , height: self.view.frame.height)
         image1View.contentMode = .ScaleAspectFit
        self.view.addSubview(image1View)
        
        let image2View = UIImageView()
        image2View.frame.origin.x = self.view.frame.width / 2
        image2View.frame.size = CGSize(width: self.view.frame.width / CGFloat(2) , height: self.view.frame.height)
        image2View.contentMode = .ScaleAspectFit
        self.view.addSubview(image2View)
        
        
        
        image1View.image = front
        image2View.image = back
        
    }
    
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Outlets
    //////////////////////////////
    //////////////////////////////
    
    @IBOutlet weak var rCTImageView: UIView!
    
    
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Actions
    //////////////////////////////
    //////////////////////////////
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
