//
//  ImageController.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/5/16. Amended by Paul Adams on 1/8/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

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
