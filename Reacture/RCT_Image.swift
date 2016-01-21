//
//  RCT_Image.swift
//  FlipPic
//
//  Created by Benjamin Patch on 1/5/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import UIKit

class RCT_Image {

    // Front is faceTime Camera (front)
    var imageFrontCIImage: CIImage

    // Back is iSight HD Camera (back)
    var imageBackCIImage: CIImage
    var originalImageFrontCIImage: CIImage
    var originalImageBackCIImage: CIImage

    // UIImage Conversion Variables
    var imageFrontUIImage: UIImage
    var imageBackUIImage: UIImage
    var layout: Layout

    init(imageFront: UIImage, imageBack: UIImage, layout: Layout = Layout(rawValue: 0)!) {
        self.imageFrontUIImage = imageFront
        self.imageBackUIImage = imageBack
        self.imageFrontCIImage = CIImage(image: imageFront)!
        self.imageBackCIImage = CIImage(image: imageBack)!
        self.originalImageFrontCIImage = imageFrontCIImage.copy() as! CIImage
        self.originalImageBackCIImage = imageBackCIImage.copy() as! CIImage
        self.layout = layout
    }
}