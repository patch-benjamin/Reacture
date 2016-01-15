//
//  RCT_EditViewController.swift
//  Reacture
//
//  Created by Ben Patch on 1/5/16. Amended by Paul Adams on 1/12/16. Amended by Eric Mead on 1/13/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit
import CoreImage

class RCT_EditViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        logAllFilters() // Uncomment to retrieve filter strings
        
        self.containerViewController = self.childViewControllers.first! as? RCT_ContainerViewController
        containerViewController?.delegate = self
        
        if let rCTImage = self.rCTImage {
            self.frontImageView.image = rCTImage.imageFrontUIImage
            self.backImageView.image = rCTImage.imageBackUIImage
        } else {
            print("ERROR: rCTImage is nil!")
        }
        setupFilters()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateWithLayout(Layout(rawValue: 0)!)
//        print("veiwDidAppear: rctImageView width: \(rCTImageView.frame.width), rctImageView height: \(rCTImageView.frame.height)")
    }
    
    func SetMockData() {
        //        let frontImage = UIImage(named: "mock_selfie")
        //        let backImage = UIImage(named: "mock_landscape")
        //        let frontImageData = RCT_ImageController.imageToData(frontImage!)!
        //        let backImageData = RCT_ImageController.imageToData(backImage!)!
        //        let image1 = RCT_ImageController.dataToImage(frontImageData)!
        //        let image2 = RCT_ImageController.dataToImage(backImageData)!
        //        rCTImageView.backgroundColor = UIColor(patternImage: image)
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
    
    // View Variables
    
    var frontImageZoomableView = PanGestureView()
    var frontImageScrollView = UIScrollView()
    var backImageZoomableView = UIView()
    var backImageScrollView = UIScrollView()
    
    // MARK: Filter Variables
    
    let context = CIContext()
    var originalFrontImage: UIImage?
    var originalBackImage: UIImage?
    var arrayOfFilterButtonImageViews: [UIImageView] = []
    
    // End Filter Variables
    
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
        
        let frontImageZoomScaleWidth = frontImageZoomableView.bounds.width / (frontImageView.image?.size.width)!
        let frontImageZoomScaleHeight = frontImageZoomableView.bounds.height / (frontImageView.image?.size.height)!
        let frontImageMinZoomScale: CGFloat
        
        frontImageZoomScaleWidth > frontImageZoomScaleHeight ? (frontImageMinZoomScale = frontImageZoomScaleWidth) : (frontImageMinZoomScale = frontImageZoomScaleHeight)
        
        self.frontImageScrollView.minimumZoomScale = frontImageMinZoomScale
        self.frontImageScrollView.maximumZoomScale = 5.0
        self.frontImageScrollView.zoomScale = frontImageMinZoomScale
        
        
        let backImageZoomScaleWidth = backImageZoomableView.bounds.width / (backImageView.image?.size.width)!
        let backImageZoomScaleHeight = backImageZoomableView.bounds.height / (backImageView.image?.size.height)!
        let backImageMinZoomScale: CGFloat
        
        backImageZoomScaleWidth > backImageZoomScaleHeight ? (backImageMinZoomScale = backImageZoomScaleWidth) : (backImageMinZoomScale = backImageZoomScaleHeight)
        
        self.backImageScrollView.minimumZoomScale = backImageMinZoomScale
        self.backImageScrollView.maximumZoomScale = 5.0
        self.backImageScrollView.zoomScale = backImageMinZoomScale
        
    }
    
    // TODO: - Change frame to bounds?
    func updateScrollViews() {
        
        print("rctImageView width: \(rCTImageView.bounds.width), rctImageView height: \(rCTImageView.bounds.height)")
        
        let frontImageZoomScaleWidth = frontImageZoomableView.bounds.width / (frontImageView.image?.size.width)!
        let frontImageZoomScaleHeight = frontImageZoomableView.bounds.height / (frontImageView.image?.size.height)!
        let frontImageMinZoomScale: CGFloat
        
        print("frontWidth: \(frontImageZoomableView.bounds.width) / \(frontImageView.image?.size.width) = \(frontImageZoomScaleWidth), frontHeight: \(frontImageZoomableView.bounds.height) / \(frontImageView.image?.size.height) = \(frontImageZoomScaleHeight)")
        
        frontImageZoomScaleWidth > frontImageZoomScaleHeight ? (frontImageMinZoomScale = frontImageZoomScaleWidth) : (frontImageMinZoomScale = frontImageZoomScaleHeight)
        
        self.frontImageScrollView.minimumZoomScale = frontImageMinZoomScale
        self.frontImageScrollView.maximumZoomScale = 5.0
        
        if frontImageScrollView.zoomScale < frontImageMinZoomScale || rCTImage?.layout == Layout.PictureInPicture {
            self.frontImageScrollView.zoomScale = frontImageMinZoomScale
        }
        
        let backImageZoomScaleWidth = backImageZoomableView.bounds.width / (backImageView.image?.size.width)!
        let backImageZoomScaleHeight = backImageZoomableView.bounds.height / (backImageView.image?.size.height)!
        let backImageMinZoomScale: CGFloat
        
        print("backWidth: \(backImageZoomableView.bounds.width) / \(backImageView.image?.size.width) = \(backImageZoomScaleWidth), backHeight: \(backImageZoomableView.bounds.height) / \(backImageView.image?.size.height) = \(backImageZoomScaleHeight)")
        
        backImageZoomScaleWidth > backImageZoomScaleHeight ? (backImageMinZoomScale = backImageZoomScaleWidth) : (backImageMinZoomScale = backImageZoomScaleHeight)
        
        self.backImageScrollView.minimumZoomScale = backImageMinZoomScale
        self.backImageScrollView.maximumZoomScale = 5.0
        
        if backImageScrollView.zoomScale < backImageMinZoomScale || rCTImage?.layout == Layout.PictureInPicture {
            self.backImageScrollView.zoomScale = backImageMinZoomScale
        }
        
    }
    
    func setupController(rCTImage: RCT_Image) {
        self.rCTImage = rCTImage
        
        let _ = self.view
        let _ = self.rCTImageView
        // setup zoomable views
        frontImageZoomableView = PanGestureView(frame: CGRectMake(0.0, 0.0, rCTImageView.bounds.width, rCTImageView.bounds.height/2))
        frontImageZoomableView.delegate = self
        backImageZoomableView = UIView(frame: CGRectMake(0.0, rCTImageView.bounds.maxY/2, rCTImageView.bounds.width, rCTImageView.bounds.height/2))
        
        rCTImageView.addSubview(backImageZoomableView)
        rCTImageView.addSubview(frontImageZoomableView)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "detectLongPress:")
        frontImageZoomableView.gestureRecognizers = [longPressRecognizer]
        
        // Setup scroll views
        frontImageScrollView = UIScrollView(frame: frontImageZoomableView.bounds)
        frontImageScrollView.delegate = self
        frontImageScrollView.backgroundColor = UIColor.blackColor()
        backImageScrollView = UIScrollView(frame: backImageZoomableView.bounds)
        backImageScrollView.delegate = self
        backImageScrollView.backgroundColor = UIColor.blackColor()
        
        frontImageZoomableView.addSubview(frontImageScrollView)
        backImageZoomableView.addSubview(backImageScrollView)
        
        // Setup Image views
        self.frontImageView = UIImageView(image: rCTImage.imageFrontUIImage)
        self.backImageView = UIImageView(image: rCTImage.imageBackUIImage)
        
        self.frontImageScrollView.addSubview(frontImageView)
        self.backImageScrollView.addSubview(backImageView)
        
        setupScrollViews()

        
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
    //    @IBOutlet weak var frontImageZoomableView: PanGestureView!
    //    @IBOutlet weak var frontImageScrollView: UIScrollView!
    //    @IBOutlet weak var frontImageView: UIImageView!
    //    @IBOutlet weak var backImageZoomableView: UIView!
    //    @IBOutlet weak var backImageScrollView: UIScrollView!
    //    @IBOutlet weak var backImageView: UIImageView!
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Actions
    //////////////////////////////
    //////////////////////////////
    
    // TODO: camelCase CancelButtonTapped
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        print("Cancel Button Tapped")
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        frontImageZoomableView.removeIsMovableView()
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
            updateWithFilter(filterSelected)
        }
    }
}

// MARK: Filter Methods

extension RCT_EditViewController {
    
    func updateWithFilter(filter: Filter) {
        
        frontImageZoomableView.removeIsMovableView()
        
        let monoFilterName = "CIPhotoEffectMono"
        let tonalFilterName = "CIPhotoEffectTonal"
        let noirFilterName = "CIPhotoEffectNoir"
        let fadeFilterName = "CIPhotoEffectFade"
        let chromeFilterName = "CIPhotoEffectChrome"
        let comicFilterName = "CIComicEffect"
        let posterFilterName = "CIColorPosterize"
        
        // Possible Future Filters Not in Use:
        //        let processFilterName = ""
        //        let transferFilterName = ""
        //        let instantFilterName = ""
        
        if self.rCTImage != nil {
            
            switch filter {
                
            case .None:
                print("None Filter Selected")
                self.frontImageView.image = self.originalFrontImage
                self.backImageView.image = self.originalBackImage
            case .Tonal:
                print("Tonal Filter Selected")
                performFilter(tonalFilterName)
            case .Noir:
                print("Noir Filter Selected")
                performFilter(noirFilterName)
            case .Fade:
                print("Fade Filter Selected")
                performFilter(fadeFilterName)
            case .Chrome:
                print("Chrome Filter Selected")
                performFilter(chromeFilterName)
            case .Comic:
                print("Comic Filter Selected")
                performFilter(comicFilterName)
            case .Poster:
                print("Poster Filter Selected")
                performFilter(posterFilterName)
            case .Count:
                print("Count Enum")
                break
            }
        }
    }
    
    func setupFilters() {
        if let rCTImage = self.rCTImage {
            self.originalFrontImage = rCTImage.imageFrontUIImage
            self.originalBackImage = rCTImage.imageBackUIImage
        }
        setupFilterThumbnails()
    }
    
    func setupFilterThumbnails() {
        
        // TODO: Put on Background Thread (asynch)
        
        let filterButtonsCount = Filter.Count.rawValue
        print("Filter Button Count is: \(Filter.Count.rawValue)")
        for var filterButtonIndex = 0; filterButtonIndex <= filterButtonsCount;
            filterButtonIndex++ {
                
                if filterButtonIndex == filterButtonsCount {
                    // All button images complete
                    // Pass to Container View to populate buttons and reload
                    let nc = NSNotificationCenter.defaultCenter()
                    nc.postNotificationName("Filter Button Images Complete", object: self, userInfo: ["filterButtonImageViews": self.arrayOfFilterButtonImageViews])
                }
                
                let filterRawValue = filterButtonIndex
                if let filterSelected = Filter(rawValue: filterRawValue) {
                    filterAllThumbnails(filterSelected)
                }
        }
    }
    
    func filterAllThumbnails(filter: Filter) {
        let tonalFilterName = "CIPhotoEffectTonal"
        let noirFilterName = "CIPhotoEffectNoir"
        let fadeFilterName = "CIPhotoEffectFade"
        let chromeFilterName = "CIPhotoEffectChrome"
        let comicFilterName = "CIComicEffect"
        let posterFilterName = "CIColorPosterize"
        
        if self.rCTImage != nil {
            
            switch filter {
                
            case .None:
                print("None Filter Selected")
                performThumbnailFilter("None")
            case .Tonal:
                print("Tonal Filter Selected")
                performThumbnailFilter(tonalFilterName)
            case .Noir:
                print("Noir Filter Selected")
                performThumbnailFilter(noirFilterName)
            case .Fade:
                print("Fade Filter Selected")
                performThumbnailFilter(fadeFilterName)
            case .Chrome:
                print("Chrome Filter Selected")
                performThumbnailFilter(chromeFilterName)
            case .Comic:
                print("Comic Filter Selected")
                performThumbnailFilter(comicFilterName)
            case .Poster:
                print("Poster Filter Selected")
                performThumbnailFilter(posterFilterName)
            case .Count:
                print("Count Enum")
                break
            }
        }
    }
    
    func performThumbnailFilter(var filterName: String) {
        var scale: CGFloat?
        var thumbnailScale: CGFloat?
        var orientation: UIImageOrientation?
        var beginFrontImage: CIImage?
        //            var beginBackImage: CIImage?
        
        let thumbnailFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        if let frontImage = self.originalFrontImage as UIImage! {
            scale = frontImage.scale
            orientation = frontImage.imageOrientation
            let height = frontImage.size.height
            let width = frontImage.size.width
            thumbnailScale = thumbnailFrame.height / height // May need aspect adjustment to make square thumbnail
            // Getting CI Image
            beginFrontImage = CIImage(image: frontImage)
        }
        //            if let backImage = self.originalBackImage as UIImage! {
        //                // Getting CI Image
        //                beginBackImage = CIImage(image: backImage)
        //            }
        
        var options: [String: AnyObject]?
        if filterName == "None" {
            filterName = "CISepiaTone"
            options = ["inputIntensity": 0]
        }
        
        // Getting Output Using Filter Name Parameter and Options
        
        // Front Image:
        if let outputImage = beginFrontImage?.imageByApplyingFilter(filterName, withInputParameters: options) {
            print("Front Thumbnail Image Name: \(filterName)")
            let cGImage: CGImageRef = self.context.createCGImage(outputImage, fromRect: outputImage.extent)
            let image = UIImage(CGImage: cGImage, scale: thumbnailScale!, orientation: orientation!)
            // Completed UI Images Update on RCT_Image Model
            let filterButtonImageView = UIImageView()
            filterButtonImageView.frame.size = thumbnailFrame.size
            filterButtonImageView.contentMode = UIViewContentMode.ScaleAspectFill // Square?
            filterButtonImageView.image = image
            // Apending to Array of Image Buttons
            arrayOfFilterButtonImageViews.append(filterButtonImageView)
        }
        
        // Back Image:
        //            if let outputImage = beginBackImage?.imageByApplyingFilter(filterName, withInputParameters: options) {
        //                print("We Have a Back Output Image")
        //                let cGImage: CGImageRef = self.context.createCGImage(outputImage, fromRect: outputImage.extent)
        //                self.rCTImage?.imageBackUIImage = UIImage(CGImage: cGImage, scale: scale!, orientation: orientation!)
        //                // Completed UI Images Update on RCT_Image Model
        //                // Reloading Back Image View
        //                self.backImageView.image = self.rCTImage!.imageBackUIImage
        //            }
    }
    
    func performFilter(filterName: String) {
        var scale: CGFloat?
        var orientation: UIImageOrientation?
        var beginFrontImage: CIImage?
        var beginBackImage: CIImage?
        
        if let frontImage = self.originalFrontImage as UIImage! {
            scale = frontImage.scale
            orientation = frontImage.imageOrientation
            
            // Getting CI Image
            beginFrontImage = CIImage(image: frontImage)
        }
        if let backImage = self.originalBackImage as UIImage! {
            // Getting CI Image
            beginBackImage = CIImage(image: backImage)
        }
        
        var options: [String: AnyObject]?
        if filterName == "CISepiaTone" {
            options = ["inputIntensity": 0.8]
        }
        
        // Getting Output Using Filter Name Parameter and Options
        
        // Front Image:
        if let outputImage = beginFrontImage?.imageByApplyingFilter(filterName, withInputParameters: options) {
            print("We Have a Front Output Image")
            let cGImage: CGImageRef = self.context.createCGImage(outputImage, fromRect: outputImage.extent)
            self.rCTImage?.imageFrontUIImage = UIImage(CGImage: cGImage, scale: scale!, orientation: orientation!)
            // Completed UI Images Update on RCT_Image Model
            // Reloading Front Image View
            self.frontImageView.image = self.rCTImage!.imageFrontUIImage
        }
        
        // Back Image:
        if let outputImage = beginBackImage?.imageByApplyingFilter(filterName, withInputParameters: options) {
            print("We Have a Back Output Image")
            let cGImage: CGImageRef = self.context.createCGImage(outputImage, fromRect: outputImage.extent)
            self.rCTImage?.imageBackUIImage = UIImage(CGImage: cGImage, scale: scale!, orientation: orientation!)
            // Completed UI Images Update on RCT_Image Model
            // Reloading Back Image View
            self.backImageView.image = self.rCTImage!.imageBackUIImage
        }
    }
    
    func logAllFilters() {
        let properties = CIFilter.filterNamesInCategory(kCICategoryStillImage)
        print("These are all Apple's available filters:\n\(properties)")
        for filterName in properties {
            let filter = CIFilter(name: filterName as String)
            print("\(filter?.attributes)")
        }
    }
}

// MARK: Layout Methods

extension RCT_EditViewController {
    
    func updateWithLayout(layout: Layout) {
        
        self.rCTImage?.layout = layout
        var frontImageX: CGFloat
        var frontImageY: CGFloat
        var frontImageWidth: CGFloat
        var frontImageHeight: CGFloat
        var backImageX: CGFloat
        var backImageY: CGFloat
        var backImageWidth: CGFloat
        var backImageHeight: CGFloat
        
        switch layout {
            
        case .TopBottom:
            
            frontImageX = 0.0
            frontImageY = 0.0
            frontImageWidth = rCTImageView.bounds.width
            frontImageHeight = rCTImageView.bounds.height/2
            backImageX = 0.0
            backImageY = rCTImageView.bounds.maxY/2
            backImageWidth = rCTImageView.bounds.width
            backImageHeight = rCTImageView.bounds.height/2
            
        case .LeftRight:
            
            frontImageX = 0.0
            frontImageY = 0.0
            frontImageWidth = rCTImageView.bounds.width/2
            frontImageHeight = rCTImageView.bounds.height
            backImageX = rCTImageView.bounds.maxX/2
            backImageY = 0.0
            backImageWidth = rCTImageView.bounds.width/2
            backImageHeight = rCTImageView.bounds.height
            
        case .PictureInPicture:
            
            let yBuffer: CGFloat = 8.0
            let xBuffer: CGFloat = 8.0
            
            frontImageX = (rCTImageView.bounds.maxX - (rCTImageView.bounds.maxX/3 + xBuffer))
            frontImageY = (rCTImageView.bounds.maxY - (rCTImageView.bounds.maxY/3 + yBuffer))
            frontImageWidth = rCTImageView.bounds.width/3
            frontImageHeight = rCTImageView.bounds.height/3
            backImageX = 0.0
            backImageY = 0.0
            backImageWidth = rCTImageView.bounds.width
            backImageHeight = rCTImageView.bounds.height
            
        case .Count:
            
            frontImageX = 0.0
            frontImageY = 0.0
            frontImageWidth = 0.0
            frontImageHeight = 0.0
            backImageX = 0.0
            backImageY = 0.0
            backImageWidth = 0.0
            backImageHeight = 0.0
        }
        
        frontImageZoomableView.frame = CGRectMake(frontImageX, frontImageY, frontImageWidth, frontImageHeight)
        backImageZoomableView.frame = CGRectMake(backImageX, backImageY, backImageWidth, backImageHeight)
        frontImageScrollView.frame = frontImageZoomableView.bounds
        backImageScrollView.frame = backImageZoomableView.bounds
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

// MARK: - PanGestureViewProtocol

extension RCT_EditViewController: PanGestureViewProtocol {
    
    func detectLongPress(recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state.rawValue == 1 && rCTImage?.layout == Layout.PictureInPicture {
            frontImageZoomableView.toggleIsMoveable()
            print("Long press ended")
        }
    }
    
    func panDetected(center: CGPoint) {

        let heightRatio = frontImageZoomableView.bounds.height/rCTImageView.bounds.height
        let widthRatio = frontImageZoomableView.bounds.width/rCTImageView.bounds.width
        let topmostBound: CGFloat = (rCTImageView.bounds.maxY * heightRatio)/2
        let bottommostBound: CGFloat = (rCTImageView.bounds.maxY - topmostBound)
        let leftmostBound: CGFloat = (rCTImageView.bounds.maxX * widthRatio)/2
        let rightmostBound: CGFloat = (rCTImageView.bounds.maxX - leftmostBound)
        var frontImageX: CGFloat = 0.0
        var frontImageY: CGFloat = 0.0
        
        if center.x <= rightmostBound && center.x >= leftmostBound {
            
            // Center.x is valid
            frontImageX = center.x
        } else {
            
            // Center.x is not valid
            if center.x > rightmostBound {
                
                // Center.x is too far right, set frontImageX to rightmostBound
                frontImageX = rightmostBound
            } else {
                
                // Center.x is too far left, set frontImageX to leftmostBound
                frontImageX = leftmostBound
            }
        }
        
        if center.y <= bottommostBound && center.y >= topmostBound {
            
            // Center.y is valid
            frontImageY = center.y
        } else {
            
            // Center.y is not valid
            if center.y > bottommostBound {
                
                // Center.y is too far down, set frontImageY to lowermostBound
                frontImageY = bottommostBound
            } else {
                
                // Center.y is too far up, set frontImageY to uppermostBound
                frontImageY = topmostBound
            }
        }
        frontImageZoomableView.center = CGPoint(x: frontImageX, y: frontImageY)
    }
}


















