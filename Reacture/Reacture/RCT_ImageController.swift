//
//  ImageController.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

class RCT_ImageController {

    // MARK: Create

    static func createRCTImage(imageFront: NSData, imageBack: NSData, layout: Layout = Layout.topBottom) -> RCT_Image {
        
        let image = RCT_Image(imageFront: UIImage(data: imageFront)!, imageBack: UIImage(data: imageBack)!, layout: layout)
        return image
    }
    
    static func createRCTImageFromImages(imageFront: UIImage, imageBack: UIImage, layout: Layout = Layout.topBottom) -> RCT_Image? {
        
        var rctImage = RCT_Image(imageFront: imageFront, imageBack: imageBack, layout: layout)
        
        return rctImage
    }

    // MARK: Read

    static func dataToImage(imageData: NSData) -> UIImage? {
        guard let image = UIImage(data: imageData) else {
            print("No image from data")
            return nil
        }
        
        return image
    }

    static func imageToData(image: UIImage) -> NSData? {
        guard let imageData: NSData = UIImageJPEGRepresentation(image, 1.0) else {
            print("No data from image")
            return nil
        }
        return imageData
    }

    // MARK: Update

    static func updateToOriginal(rCTImage: RCT_Image) {
        print("test: updated image to original")
    }

    // MARK: Delete

    static func deleteRCTImage(rCTImage: RCT_Image) {
        print("test: Deleted image")
    }
}