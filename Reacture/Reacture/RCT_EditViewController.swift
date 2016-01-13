//
//  RCT_EditViewController.swift
//  Reacture
//
//  Created by Ben Patch on 1/5/16. Amended by Paul Adams on 1/12/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

class RCT_EditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerViewController = self.childViewControllers.first! as? RCT_ContainerViewController
        self.containerViewController?.delegate = self

        if let rCTImage = self.rCTImage {
//            self.setupZoomableImageViews(rCTImage)
            self.frontImageView.image = rCTImage.imageFrontUIImage
            self.backImageView.image = rCTImage.imageBackUIImage
            
        } else {
            print("ERROR: rCTImage is nil!")
        }

//        setupController(self.rCTImage)
        
        setupScrollViews()
        
    }

    func SetMockData() {
        let frontImage = UIImage(named: "mock_selfie")
        let backImage = UIImage(named: "mock_landscape")
        let frontImageData = RCT_ImageController.imageToData(frontImage!)!
        let backImageData = RCT_ImageController.imageToData(backImage!)!
        let image1 = RCT_ImageController.dataToImage(frontImageData)!
        let image2 = RCT_ImageController.dataToImage(backImageData)!
        //rCTImageView.backgroundColor = UIColor(patternImage: image)
        //        setUpImages(image1, back: image2)
    }


    //////////////////////////////
    //////////////////////////////
    // MARK: Variables
    //////////////////////////////
    //////////////////////////////

    var imageToSend: UIImage?
    var rCTImage: RCT_Image?
    var containerViewController: RCT_ContainerViewController?
    var frontImageView = UIImageView()
    var backImageView = UIImageView()
    
    
//    let frontImageZoomableView: UIView = UIView()
//    let backImageZoomableView: UIView = UIView()
//    let frontImageScrollView = UIScrollView()
//    let backImageScrollView = UIScrollView()
//    let frontImageView = UIImageView()
//    let backImageView = UIImageView()
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Functions
    //////////////////////////////
    //////////////////////////////

    func setupScrollViews() {
        
        let frontImageMinZoomScale = frontImageZoomableView.frame.width / (frontImageView.image?.size.width)!
        self.frontImageScrollView.minimumZoomScale = frontImageMinZoomScale
        self.frontImageScrollView.maximumZoomScale = 5.0
        self.frontImageScrollView.zoomScale = frontImageMinZoomScale
        self.frontImageScrollView.addSubview(frontImageView)
        
        
        let backImageMinZoomScale = backImageZoomableView.frame.width / (backImageView.image?.size.width)!
        self.backImageScrollView.minimumZoomScale = backImageMinZoomScale
        self.backImageScrollView.maximumZoomScale = 5.0
        self.backImageScrollView.zoomScale = backImageMinZoomScale
        self.backImageScrollView.addSubview(backImageView)
        
    }
    
    func updateScrollViews() {
        
        let frontImageMinZoomScale = frontImageZoomableView.frame.width / (frontImageView.image?.size.width)!
        self.frontImageScrollView.minimumZoomScale = frontImageMinZoomScale
        self.frontImageScrollView.maximumZoomScale = 5.0
        
        if frontImageScrollView.zoomScale < frontImageMinZoomScale {
            self.frontImageScrollView.zoomScale = frontImageMinZoomScale
        }
        
        let backImageMinZoomScale = backImageZoomableView.frame.width / (backImageView.image?.size.width)!
        self.backImageScrollView.minimumZoomScale = backImageMinZoomScale
        self.backImageScrollView.maximumZoomScale = 5.0

        if backImageScrollView.zoomScale < backImageMinZoomScale {
            self.backImageScrollView.zoomScale = backImageMinZoomScale
        }

    }
    
    func setupController(rCTImage: RCT_Image) {
        self.rCTImage = rCTImage
        self.frontImageView = UIImageView(image: rCTImage.imageFrontUIImage)
        self.backImageView = UIImageView(image: rCTImage.imageBackUIImage)
    }

    func setUpImages(front: UIImage, back: UIImage){
//        let image1View = UIImageView()
//        image1View.frame.origin.x = self.view.frame.origin.x
//        image1View.frame.size = CGSize(width: self.view.frame.width / CGFloat(2) , height: self.view.frame.height)
//        image1View.contentMode = .ScaleAspectFit
//        self.view.addSubview(image1View)
//        let image2View = UIImageView()
//        image2View.frame.origin.x = self.view.frame.width / 2
//        image2View.frame.size = CGSize(width: self.view.frame.width / CGFloat(2) , height: self.view.frame.height)
//        image2View.contentMode = .ScaleAspectFit
//        self.view.addSubview(image2View)
//        image1View.image = front
//        image2View.image = back
    }

    func imageCapture() {
        print("Attempted Image Capture")
        UIGraphicsBeginImageContextWithOptions(rCTImageView.frame.size, view.opaque, 0.0)
        rCTImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        self.imageToSend = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    //////////////////////////////
    //////////////////////////////
    // MARK: Outlets
    //////////////////////////////
    //////////////////////////////

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
//    @IBOutlet weak var cVToptoToolbarTopConstraint: NSLayoutConstraint!
    //
    //    @IBOutlet weak var cVHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var rCTImageView: UIView!
    @IBOutlet weak var frontImageZoomableView: UIView!
    @IBOutlet weak var frontImageScrollView: UIScrollView!
//    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageZoomableView: UIView!
    @IBOutlet weak var backImageScrollView: UIScrollView!
//    @IBOutlet weak var backImageView: UIImageView!

    
    // Constraint Outlets
    @IBOutlet weak var frontImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontImageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var frontImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontImageBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var backImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var backImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    
    
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
        imageCapture()
        print("Share Button Tapped")
        let shareTextRCTImage = "Shared with #reacture"
        if let image = self.imageToSend {
            print("Sending Image")
            let shareViewController = UIActivityViewController(activityItems: [image, shareTextRCTImage], applicationActivities: nil)
            shareViewController.popoverPresentationController?.sourceView = self.view
            self.presentViewController(shareViewController, animated: true, completion: nil)
        }
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
//        if self.cVToptoToolbarTopConstraint.constant == 100 {
//            self.containerView.alpha = 0
//        } else {
//            self.containerView.alpha = 1
//        }
//        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.CurveEaseInOut], animations: { () -> Void in
//            if self.cVToptoToolbarTopConstraint.constant == 100 {
//                self.cVToptoToolbarTopConstraint.constant = 0.1
//            } else {
//                self.cVToptoToolbarTopConstraint.constant = 100
//            }
//            }, completion: {_ in
//                print("Container View Animation Complete")
//        })
    }

}

extension RCT_EditViewController: RCT_ContainerViewControllerProtocol {

    func itemSelected(indexPath: NSIndexPath) {
        if kIsLayoutSelected! {
            let layoutSelected = Layout(rawValue: indexPath.item)!
            
            updateWithLayout(layoutSelected)
            
        } else {
            let filterSelected = Filter(rawValue: indexPath.item)!
            RCT_FiltersController.updateWithFilter(filterSelected, rCTImage: self.rCTImage!)
        }
    }
    
}



// MARK: Layout Methods
extension RCT_EditViewController {
    
    
    func updateWithLayout(layout: Layout) {
        
        self.rCTImage?.layout = layout
        
        removeLayoutConstraints()
        
        frontImageZoomableView.frame = CGRectMake(frontImageZoomableView.frame.minX, frontImageZoomableView.frame.minY, rCTImageView.frame.width, rCTImageView.frame.height)
        backImageZoomableView.frame = CGRectMake(backImageZoomableView.frame.minX, backImageZoomableView.frame.minY, rCTImageView.frame.width, rCTImageView.frame.height)

        switch layout {
        case .LeftRight:
            
//            frontImageHeightConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Height, relatedBy: .Equal, toItem: rCTImageView, attribute: .Height, multiplier: 1.0, constant: 0)
            frontImageWidthConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Width, relatedBy: .Equal, toItem: rCTImageView, attribute: .Width, multiplier: 0.5, constant: 0)
            
            frontImageLeadingConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Leading, relatedBy: .Equal, toItem: rCTImageView, attribute: .Leading, multiplier: 1.0, constant: 0)
//            frontImageTrailingConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Trailing, relatedBy: .Equal, toItem: backImageZoomableView, attribute: .Leading, multiplier: 1.0, constant: 0)
            frontImageTopConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Top, relatedBy: .Equal, toItem: rCTImageView, attribute: .Top, multiplier: 1.0, constant: 0)
            frontImageBottomConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Bottom, relatedBy: .Equal, toItem: rCTImageView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            
            
//            backImageHeightConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Height, relatedBy: .Equal, toItem: rCTImageView, attribute: .Height, multiplier: 1.0, constant: 0)
            backImageWidthConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Width, relatedBy: .Equal, toItem: rCTImageView, attribute: .Width, multiplier: 0.5, constant: 0)
            
//            backImageLeadingConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Leading, relatedBy: .Equal, toItem: frontImageZoomableView, attribute: .Trailing, multiplier: 1.0, constant: 0)
            backImageTrailingConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Trailing, relatedBy: .Equal, toItem: rCTImageView, attribute: .Trailing, multiplier: 1.0, constant: 0)
            backImageTopConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Top, relatedBy: .Equal, toItem: rCTImageView, attribute: .Top, multiplier: 1.0, constant: 0)
            backImageBottomConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Bottom, relatedBy: .Equal, toItem: rCTImageView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            
        case .TopBottom:
            
            
            frontImageHeightConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Height, relatedBy: .Equal, toItem: rCTImageView, attribute: .Height, multiplier: 0.5, constant: 0)
//            frontImageWidthConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Width, relatedBy: .Equal, toItem: rCTImageView, attribute: .Width, multiplier: 1.0, constant: 0)
            
            frontImageLeadingConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Leading, relatedBy: .Equal, toItem: rCTImageView, attribute: .Leading, multiplier: 1.0, constant: 0)
            frontImageTrailingConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Trailing, relatedBy: .Equal, toItem: rCTImageView, attribute: .Trailing, multiplier: 1.0, constant: 1)
            frontImageTopConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Top, relatedBy: .Equal, toItem: rCTImageView, attribute: .Top, multiplier: 1.0, constant: 0)
//            frontImageBottomConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Bottom, relatedBy: .Equal, toItem: backImageZoomableView, attribute: .Top, multiplier: 1.0, constant: 0)
            
            
            backImageHeightConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Height, relatedBy: .Equal, toItem: rCTImageView, attribute: .Height, multiplier: 0.5, constant: 0)
//            backImageWidthConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Width, relatedBy: .Equal, toItem: rCTImageView, attribute: .Width, multiplier: 1.0, constant: 0)
            
            backImageLeadingConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Leading, relatedBy: .Equal, toItem: rCTImageView, attribute: .Leading, multiplier: 1.0, constant: 0)
            backImageTrailingConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Trailing, relatedBy: .Equal, toItem: rCTImageView, attribute: .Trailing, multiplier: 1.0, constant: 0)
//            backImageTopConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Top, relatedBy: .Equal, toItem: frontImageZoomableView, attribute: .Bottom, multiplier: 1.0, constant: 0)
            backImageBottomConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Bottom, relatedBy: .Equal, toItem: rCTImageView, attribute: .Bottom, multiplier: 1.0, constant: 0)

        case .PictureInPicture:

            frontImageZoomableView.frame = CGRectMake(frontImageZoomableView.frame.minX, frontImageZoomableView.frame.minY, rCTImageView.frame.width/2, rCTImageView.frame.height/2)
            
            backImageZoomableView.frame = CGRectMake(backImageZoomableView.frame.minX, backImageZoomableView.frame.minY, rCTImageView.frame.width, rCTImageView.frame.height)

            
            frontImageHeightConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Height, relatedBy: .Equal, toItem: rCTImageView, attribute: .Height, multiplier: 0.5, constant: 0)
            frontImageWidthConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .Width, relatedBy: .Equal, toItem: rCTImageView, attribute: .Width, multiplier: 0.5, constant: 0)
            
            frontImageTrailingConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: rCTImageView, attribute: .CenterX, multiplier: 1.5, constant: 0)
            
            frontImageBottomConstraint = NSLayoutConstraint(item: frontImageZoomableView, attribute: .CenterY, relatedBy: .Equal, toItem: rCTImageView, attribute: .CenterX, multiplier: 1.5, constant: 0)
            
            
//            backImageHeightConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Height, relatedBy: .Equal, toItem: rCTImageView, attribute: .Height, multiplier: 1.0, constant: 0)
//            backImageWidthConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Width, relatedBy: .Equal, toItem: rCTImageView, attribute: .Width, multiplier: 1.0, constant: 0)
            
            backImageLeadingConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Leading, relatedBy: .Equal, toItem: rCTImageView, attribute: .Leading, multiplier: 1.0, constant: 0)
            backImageTrailingConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Trailing, relatedBy: .Equal, toItem: rCTImageView, attribute: .Trailing, multiplier: 1.0, constant: 0)
            backImageTopConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Top, relatedBy: .Equal, toItem: rCTImageView, attribute: .Top, multiplier: 1.0, constant: 0)
            backImageBottomConstraint = NSLayoutConstraint(item: backImageZoomableView, attribute: .Bottom, relatedBy: .Equal, toItem: rCTImageView, attribute: .Bottom, multiplier: 1.0, constant: 0)

        case .Count:
            break
        }
        
        addLayoutConstraints()
        
    }
    
    func removeLayoutConstraints() {
        
       
        [self.frontImageHeightConstraint, self.frontImageWidthConstraint, self.frontImageLeadingConstraint, self.frontImageTrailingConstraint, self.frontImageTopConstraint, self.frontImageBottomConstraint, self.backImageHeightConstraint, self.backImageWidthConstraint, self.backImageLeadingConstraint, self.backImageTrailingConstraint, self.backImageTopConstraint, self.backImageBottomConstraint].forEach { (constraint) -> () in
            if constraint != nil {
                rCTImageView.removeConstraint(constraint)
            }
        }
    }
    
    func addLayoutConstraints() {
        
        [self.frontImageHeightConstraint, self.frontImageWidthConstraint, self.frontImageLeadingConstraint, self.frontImageTrailingConstraint, self.frontImageTopConstraint, self.frontImageBottomConstraint, self.backImageHeightConstraint, self.backImageWidthConstraint, self.backImageLeadingConstraint, self.backImageTrailingConstraint, self.backImageTopConstraint, self.backImageBottomConstraint].forEach { (constraint) -> () in
            if constraint != nil {
                rCTImageView.addConstraint(constraint)
            }
        }
        print("frontView width: \(frontImageZoomableView.frame.size.width), scrollView width: \(frontImageScrollView.frame.size.width), rctImageView width: \(rCTImageView.frame.size.width)")
        
        updateScrollViews()
    }
    
    
    
    
}


extension RCT_EditViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView == self.frontImageScrollView {
            return self.frontImageView
        } else {
            return self.backImageView
        }
    }
    
}

