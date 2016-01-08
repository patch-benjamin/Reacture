//
//  ImageController.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/5/16. Amended by Paul Adams on 1/8/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import Foundation
import UIKit

class RCT_ImageController {

    // MARK: Create

    static func createRCTImage(imageFront: NSData, imageBack: NSData, layout: Layout = Layout.topBottom) -> RCT_Image {
        let image = RCT_Image(imageFront: imageFront, imageBack: imageBack, layout: layout)
        return image
    }

    // MARK: Read

    static func dataToImage(imageData: NSData) -> UIImage? {
        guard let image = UIImage(data: imageData) else {
            print("No Image from Data")
            return nil
        }
        return image
    }

    static func imageToData(image: UIImage) -> NSData? {
        guard let imageData: NSData = UIImageJPEGRepresentation(image, 1.0) else {
            print("No Data from Image")
            return nil
        }
        return imageData
    }

    // MARK: Update

    static func updateToOriginal(rCTImage: RCT_Image) {
        rCTImage.layout = Layout.topBottom
        rCTImage.imageBackCIImage = rCTImage.originalImageBackCIImage
        rCTImage.imageFrontCIImage = rCTImage.originalImageFrontCIImage
        print("Test: Updated Image to Original")
    }

//    // MARK: Delete
//
//    static func deleteRCTImage(rCTImage: RCT_Image) {
//        print("Test: Deleted Image")
//    }
}

/*
protocol UIViewControllerSubset {
    func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?)
    func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

protocol RCT_SelectImageControllerDelegate : UIViewControllerSubset {
    func imageControllerDidCancel(selectImageController : RCT_SelectImageController)
    func imageControllerDidSelectImage(selectImageController : RCT_SelectImageController, selectedImage : UIImage)
}

class RCT_SelectImageController : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties

    let hostViewController : RCT_SelectImageControllerDelegate

    private var alertController : UIAlertController?

    // MARK: Init

    required init(withHostViewController hostViewController : RCT_SelectImageControllerDelegate) {
        self.hostViewController = hostViewController
    }

    // MARK: Action Methods

    func showImageSelectOptionsWithTitle(title : String) {
        self.alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        self.setUpAlertController()
        self.hostViewController .presentViewController(self.alertController!, animated: true, completion: nil)
    }

    func setUpAlertController() {
        if let optionAlertContontroller = self.alertController {
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action : UIAlertAction) -> Void in
                self.hostViewController.imageControllerDidCancel(self)
            }
            let imageLibraryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.Default) { (action : UIAlertAction) -> Void in
                self.showLibrary()
            }
            optionAlertContontroller.addAction(cancel)
            optionAlertContontroller.addAction(imageLibraryAction)
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action : UIAlertAction) -> Void in
                    self.showCamera()
                }
                optionAlertContontroller.addAction(cameraAction)
            }
        }
    }

    // MARK: Show Library

    private func showLibrary() {
        let imagePickerController = self.createImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.hostViewController.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    // MARK: Show Camera

    private func showCamera() {
        let imagePickerController = createImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.hostViewController.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    private func createImagePickerController() -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }

    // MARK: Image Picker Controller Delegate

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.hostViewController .dismissViewControllerAnimated(true, completion: nil)
        self.hostViewController.imageControllerDidCancel(self)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.hostViewController .dismissViewControllerAnimated(true, completion: nil)
        self.hostViewController.imageControllerDidSelectImage(self, selectedImage: image)
    }
}
*/