//
//  RCT_EditViewController.swift
//  Reacture
//
//  Created by Ben Patch on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

class RCT_EditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cVToptoToolbarTopConstraint.constant = 100
        self.containerViewController = self.childViewControllers.first! as? RCT_ContainerViewController
        self.containerViewController?.delegate = self
        SetMockData()
    }
    
    func SetMockData() {
        let frontImage = UIImage(named: "mock_selfie")
        let backImage = UIImage(named: "mock_landscape")
        let frontImageData = RCT_ImageController.imageToData(frontImage!)!
        let backImageData = RCT_ImageController.imageToData(backImage!)!
        let image1 = RCT_ImageController.dataToImage(frontImageData)!
        let image2 = RCT_ImageController.dataToImage(backImageData)!
        //rCTImageView.backgroundColor = UIColor(patternImage: image)
        setUpImages(image1, back: image2)
    }


    //////////////////////////////
    //////////////////////////////
    // MARK: Variables
    //////////////////////////////
    //////////////////////////////

    var rCTImage: RCT_Image?
    var containerViewController: RCT_ContainerViewController?

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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var cVToptoToolbarTopConstraint: NSLayoutConstraint!
    //
    //    @IBOutlet weak var cVHeightContraint: NSLayoutConstraint!

    //////////////////////////////
    //////////////////////////////
    // MARK: Actions
    //////////////////////////////
    //////////////////////////////

    @IBAction func CancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        print("Cancel Button Tapped")
    }

    @IBAction func shareButtonTapped(sender: AnyObject) {
        print("Share Button Tapped")
        let shareTextRCTImage = "Shared with #reacture"
        let shareImageRCTImage: UIImage = UIImage(named: "mock_selfie")!
        let shareViewController: UIActivityViewController = UIActivityViewController(activityItems: [(shareImageRCTImage), shareTextRCTImage], applicationActivities: nil)
        self.presentViewController(shareViewController, animated: true, completion: nil)
    }
    
    @IBAction func layoutButtonTapped(sender: AnyObject) {
        print("Layout Button Tapped")
        //animateContainerView()
        
        // Send Collection View "isLayoutSelected" == true
        kIsLayoutSelected = true
        // Reload Collection View Data
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("reloadCollectionView", object: self)
    }

    @IBAction func filterButtonTapped(sender: AnyObject) {
        print("Filter Button Tapped")
        //animateContainerView()
        // Send Collection View "isLayoutSelected" == false
        kIsLayoutSelected = false
        // Reload Collection View Data
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("reloadCollectionView", object: self)
    }

    func animateContainerView() {
        if self.cVToptoToolbarTopConstraint.constant == 100 {
            self.containerView.alpha = 0
        } else {
            self.containerView.alpha = 1
        }
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.CurveEaseInOut], animations: { () -> Void in
            if self.cVToptoToolbarTopConstraint.constant == 100 {
                self.cVToptoToolbarTopConstraint.constant = 0.1
            } else {
                self.cVToptoToolbarTopConstraint.constant = 100
            }
            }, completion: {_ in
                print("Container View Animation Complete")
        })
    }

}


extension RCT_EditViewController: RCT_ContainerViewControllerProtocol {
    
    func itemSelected(indexPath: NSIndexPath) {
        
        if kIsLayoutSelected! {
            
            let layoutSelected = Layout(rawValue: indexPath.item)!
            
            RCT_LayoutController.updateWithLayout(layoutSelected, image: self.rCTImage!, view: self.rCTImageView)
            
        } else {
            
            let filterSelected = Filter(rawValue: indexPath.item)!
            
            RCT_FiltersController.updateWithFilter(filterSelected, rCTImage: self.rCTImage!)
            
        }
        
    }
    
}
