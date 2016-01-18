//
//  RCT_EditViewController.swift
//  Reacture
//
//  Created by Ben Patch & Andrew Porter on 1/5/16. Amended by Paul Adams & Eric Mead on 1/12/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit
import CoreImage

class RCT_EditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()

        //        logAllFilters() // Uncomment to retrieve filter strings

        self.containerViewController = self.childViewControllers.first! as? RCT_ContainerViewController
        containerViewController?.delegate = self

        if let rCTImage = self.rCTImage {
            self.frontImageView.image = rCTImage.imageFrontUIImage
            self.backImageView.image = rCTImage.imageBackUIImage
            self.setupSwapImageButton()
        } else {
            print("ERROR: rCTImage is nil!")
        }
        setupFilters()
        self.rCTImageView.frame.size = CGSize(width: view.bounds.width, height: view.bounds.width)
        updateWithLayout(rCTImage!.layout)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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

    //MARK: Swap Button:
    var swapImageButton = UIButton()
    var imagesAreSwapped: Bool = false
    var imageToSend: UIImage?
    var rCTImage: RCT_Image?
    var containerViewController: RCT_ContainerViewController?
    var frontImageView = UIImageView()
    var backImageView = UIImageView()

    // View Variables

    var frontImageZoomableView = PanGestureView()
    var frontImageScrollView = UIScrollView()
    var backImageZoomableView = ZoomableView()
    var backImageScrollView = UIScrollView()
    
    // Adjusting layout view variables
    var adjustLayoutView = UIView()
    var adjustLayoutViewLastPosition = CGPoint()
    var frontImageLastFrame = CGRect()
    var backImageLastFrame = CGRect()
    static let lineWidth: CGFloat = 10.0


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

    func setupAdjustLayoutView() {
        
        self.adjustLayoutView.frame = self.rCTImageView!.frame
        self.adjustLayoutView.backgroundColor = UIColor.whiteColor()
        self.rCTImageView.addSubview(adjustLayoutView)
        adjustLayoutView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "adjustLayoutView:"))
        updateLayoutViewForLayout()
        
    }
    
    func updateLayoutViewForLayout() {
        
        adjustLayoutView.hidden = false
        
        switch rCTImage!.layout {
            
        case .TopBottom:
            
            adjustLayoutView.frame = CGRectMake(0.0, 0.0, rCTImageView.frame.width, RCT_EditViewController.lineWidth)
            adjustLayoutView.center = CGPoint(x: rCTImageView.bounds.maxX/2, y: rCTImageView.bounds.maxY/2)
            
        case .LeftRight:
            
            adjustLayoutView.frame = CGRectMake(0.0, 0.0, RCT_EditViewController.lineWidth, rCTImageView.frame.height)
            adjustLayoutView.center = CGPoint(x: rCTImageView.bounds.maxX/2, y: rCTImageView.bounds.maxY/2)

        default:
            adjustLayoutView.hidden = true
        }
        
        rCTImageView.bringSubviewToFront(adjustLayoutView)

    }

    func adjustLayoutView(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            
            adjustLayoutViewLastPosition = adjustLayoutView.center
            frontImageLastFrame = frontImageZoomableView.frame
            backImageLastFrame = backImageZoomableView.frame
        }
        
        let translation = recognizer.translationInView(self.rCTImageView)
        switch rCTImage!.layout {
            
        case .TopBottom:
            var layoutViewY: CGFloat = adjustLayoutViewLastPosition.y + translation.y
            let adjustmentBuffer = rCTImageView.frame.height/4 // each image must be at least 1/4 of the rCTImageView
            let uppermostBound: CGFloat = (rCTImageView.bounds.minY + adjustmentBuffer)
            let lowermostBound: CGFloat = (rCTImageView.bounds.maxY - adjustmentBuffer)
            var frontImageHeight: CGFloat = frontImageLastFrame.height + translation.y
            var backImageHeight: CGFloat = backImageLastFrame.height - translation.y
            var backImageY: CGFloat = backImageLastFrame.origin.y + translation.y
            
            // Check for invalid Y position
            if layoutViewY > lowermostBound {
                
                layoutViewY = lowermostBound

                let yPositionPercentage = (lowermostBound / rCTImageView.bounds.maxY)
                frontImageHeight =  rCTImageView.bounds.height * yPositionPercentage
                backImageHeight = rCTImageView.bounds.height - (rCTImageView.bounds.height * yPositionPercentage) // width times percentage of where the x point is.
                backImageY = lowermostBound
                print("rCTImageView.bounds.height: \(rCTImageView.bounds.height); yPositionPercentage: \(yPositionPercentage)")

            } else if layoutViewY < uppermostBound {
                
                layoutViewY = uppermostBound

                let yPositionPercentage = (uppermostBound / rCTImageView.bounds.maxY)
                frontImageHeight =  rCTImageView.bounds.height * yPositionPercentage
                backImageHeight = rCTImageView.bounds.height - (rCTImageView.bounds.height * yPositionPercentage) // width times percentage of where the x point is.
                backImageY = uppermostBound

            }
            
            adjustLayoutView.center = CGPoint(x: rCTImageView.bounds.maxX/2, y: layoutViewY)
            frontImageZoomableView.frame.size.height = frontImageHeight
            backImageZoomableView.frame.size.height = backImageHeight
            backImageZoomableView.frame.origin.y = backImageY
            
        case .LeftRight:
            
            var layoutViewX: CGFloat = adjustLayoutViewLastPosition.x + translation.x
            let adjustmentBuffer = rCTImageView.frame.width/4 // each image must be at least 1/4 of the rCTImageView
            let rightmostBound: CGFloat = (rCTImageView.bounds.maxX - adjustmentBuffer)
            let leftmostBound: CGFloat = (rCTImageView.bounds.minX + adjustmentBuffer)
            var frontImageWidth = frontImageLastFrame.width + translation.x
            var backImageWidth = backImageLastFrame.width - translation.x
            var backImageX = backImageLastFrame.origin.x + translation.x

            // Check for invalid X position
            if layoutViewX > rightmostBound {
                
                layoutViewX = rightmostBound
                
                let xPositionPercentage = (rightmostBound / rCTImageView.bounds.maxX)
                frontImageWidth = rCTImageView.bounds.width * xPositionPercentage
                backImageWidth = rCTImageView.bounds.width - (rCTImageView.bounds.width * xPositionPercentage) // width times percentage of where the x point is.
                backImageX = rightmostBound

            } else if layoutViewX < leftmostBound {
                
                layoutViewX = leftmostBound
                
                let xPositionPercentage = (leftmostBound / rCTImageView.bounds.maxX)
                frontImageWidth =  rCTImageView.bounds.width * xPositionPercentage
                backImageWidth = rCTImageView.bounds.width - (rCTImageView.bounds.width * xPositionPercentage) // width times percentage of where the x point is.
                backImageX = leftmostBound

            }
            
            adjustLayoutView.center = CGPoint(x: layoutViewX, y: rCTImageView.bounds.maxY/2)
            frontImageZoomableView.frame.size.width = frontImageWidth
            backImageZoomableView.frame.size.width = backImageWidth
            backImageZoomableView.frame.origin.x = backImageX
            
        default:
            
            break
        }

            frontImageScrollView.frame = frontImageZoomableView.bounds
            backImageScrollView.frame = backImageZoomableView.bounds
    }
    
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

        centerImagesOnYAxis()
    }

    func centerImagesOnYAxis(animated: Bool = false) {

        // offset it by the difference of size divided by two. this makes the center of the image at the center of the scrollView.
        let frontY = (frontImageScrollView.contentSize.height - frontImageScrollView.bounds.height)/2
        let backY = (backImageScrollView.contentSize.height - backImageScrollView.bounds.height)/2
        print("\(frontImageScrollView.contentSize.height) \(backImageScrollView.contentSize.height)")
        frontImageScrollView.setContentOffset(CGPoint(x: 0, y: frontY), animated: animated)
        backImageScrollView.setContentOffset(CGPoint(x: 0, y: backY), animated: animated)

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
        backImageZoomableView = ZoomableView(frame: CGRectMake(0.0, rCTImageView.bounds.maxY/2, rCTImageView.bounds.width, rCTImageView.bounds.height/2))

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
        frontImageZoomableView.scrollView = frontImageScrollView
        backImageZoomableView.addSubview(backImageScrollView)
        backImageZoomableView.scrollView = frontImageScrollView

        // Setup Image views
        self.frontImageView = UIImageView(image: rCTImage.imageFrontUIImage)
        self.backImageView = UIImageView(image: rCTImage.imageBackUIImage)

        self.frontImageScrollView.addSubview(frontImageView)
        self.backImageScrollView.addSubview(backImageView)

        setupScrollViews()
        setupAdjustLayoutView()

        rCTImageView.updateBorderForLayout(.BigPicture)
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

    func swapImages(withAnimation: Bool = true) {

        print("frontImageZoom: \(frontImageScrollView.zoomScale); backImageZoom: \(backImageScrollView.zoomScale)")
        print("frontImageMinZoom: \(frontImageScrollView.minimumZoomScale); backImageMinZoom: \(backImageScrollView.minimumZoomScale)")


        imagesAreSwapped = !imagesAreSwapped
        print("Swap Image Button Tapped")
        let currentBackImage = self.rCTImage?.imageBackUIImage
        let currentFrontImage = self.rCTImage?.imageFrontUIImage
        self.rCTImage?.imageBackUIImage = currentFrontImage!
        self.rCTImage?.imageFrontUIImage = currentBackImage!
        let tempImage = self.originalBackImage
        self.originalBackImage = self.originalFrontImage
        self.originalFrontImage = tempImage
        
        if withAnimation {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            frontImageView.image = self.rCTImage?.imageFrontUIImage
            backImageView.image = self.rCTImage?.imageBackUIImage

            centerImagesOnYAxis()
            self.frontImageScrollView.zoomScale = self.frontImageScrollView.minimumZoomScale
            self.backImageScrollView.zoomScale = self.backImageScrollView.minimumZoomScale

            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.frontImageView.alpha = 1
                self.backImageView.alpha = 1
                }, completion: { (_) -> Void in
            })
        } else {
            frontImageView.image = self.rCTImage?.imageFrontUIImage
            backImageView.image = self.rCTImage?.imageBackUIImage
        }
    }

    func clearSwappedImages() {
        if imagesAreSwapped {
            swapImages(false)
        }
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

    @IBAction func swapImageButtonTapped(sender: AnyObject) {
        //        if swapImageButton.imageView!.image == UIImage(named: "image1"){
        //            self.swapImageButton.setBackgroundImage(UIImage(named: "image2"), forState: .Normal)
        //        } else {
        //            //it is image2
        //            self.swapImageButton.setBackgroundImage(UIImage(named: "image1"), forState: .Normal)
        //        }
        swapImages()
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
        frontImageZoomableView.removeIsMovableView()
    }

    @IBAction func filterButtonTapped(sender: AnyObject) {
        print("Filter Button Tapped")
        //animateContainerView()
        // Send Collection View "isLayoutSelected" == false
        kIsLayoutSelected = false
        // Reload Collection View Data
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("reloadCollectionView", object: self)
        frontImageZoomableView.removeIsMovableView()
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

    func setupSwapImageButton() {
        let size = CGSize(width: 50, height: 50)
        swapImageButton.frame.size = size
        swapImageButton.center.x = self.view.center.x
        swapImageButton.center.y = 40
        swapImageButton.backgroundColor = UIColor.clearColor()
        swapImageButton.setBackgroundImage(UIImage(named: "swapImagesButton"), forState: .Normal)
        swapImageButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        swapImageButton.alpha = 0.9
        swapImageButton.addTarget(self, action: "swapImageButtonTapped:", forControlEvents: .TouchUpInside)
        self.view.addSubview(swapImageButton)
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

    func clearMasks() {

        self.frontImageZoomableView.maskLayout = MaskLayout.None
        self.backImageZoomableView.maskLayout = MaskLayout.None
        RCT_LayoutController.isCornersLayout = false
    }

    func updateWithLayout(layout: Layout) {

        self.rCTImage?.layout = layout
        clearMasks()
        clearSwappedImages()
        updateLayoutViewForLayout()

        frontImageZoomableView.removeBorders()
        backImageZoomableView.removeBorders()
        
        var frontImageX: CGFloat
        var frontImageY: CGFloat
        var frontImageWidth: CGFloat
        var frontImageHeight: CGFloat
        var backImageX: CGFloat
        var backImageY: CGFloat
        var backImageWidth: CGFloat
        var backImageHeight: CGFloat
        
        var frontImageSubLayout = SubLayout.None
        var backImageSubLayout = SubLayout.None

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
            
            // Add Borders
            frontImageSubLayout = SubLayout.LittlePicture

        case .UpperLeftLowerRight:

            RCT_LayoutController.isCornersLayout = true
            frontImageX = 0.0
            frontImageY = 0.0
            frontImageWidth = rCTImageView.bounds.width
            frontImageHeight = rCTImageView.bounds.height
            backImageX = 0.0
            backImageY = 0.0
            backImageWidth = rCTImageView.bounds.width
            backImageHeight = rCTImageView.bounds.height

            frontImageZoomableView.maskLayout = MaskLayout.TopLeft
            backImageZoomableView.maskLayout = MaskLayout.BottomRight
            
            // Add Borders
            frontImageSubLayout = SubLayout.TopLeft
            backImageSubLayout = SubLayout.BottomRight

        case .UpperRightLowerLeft:

            RCT_LayoutController.isCornersLayout = true
            frontImageX = 0.0
            frontImageY = 0.0
            frontImageWidth = rCTImageView.bounds.width
            frontImageHeight = rCTImageView.bounds.height
            backImageX = 0.0
            backImageY = 0.0
            backImageWidth = rCTImageView.bounds.width
            backImageHeight = rCTImageView.bounds.height

            frontImageZoomableView.maskLayout = MaskLayout.TopRight
            backImageZoomableView.maskLayout = MaskLayout.BottomLeft
            
            // Add Borders
            frontImageSubLayout = SubLayout.TopRight
            backImageSubLayout = SubLayout.BottomLeft

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

        // set the borders
        frontImageZoomableView.updateBorderForLayout(frontImageSubLayout)
        backImageZoomableView.updateBorderForLayout(backImageSubLayout)

        updateScrollViews()
        frontImageZoomableView.removeIsMovableView()
        
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

    
    
    // Pan gesture for moving image in image layout.
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