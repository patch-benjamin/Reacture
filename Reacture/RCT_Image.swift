//
//  RCT_Image.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

class RCT_Image {
    
    // Front is faceTime Camera
    var imageFrontCIImage: CIImage
    // Back is the larger, main Camera
    var imageBackCIImage: CIImage
    
    var originalImageFrontCIImage: CIImage
    var originalImageBackCIImage: CIImage
    
    // UIImage Conversion Variables
    var imageFrontUIImage: UIImage { return UIImage(CIImage: self.imageFrontCIImage) }
    var imageBackUIImage: UIImage { return UIImage(CIImage: self.imageBackCIImage) }
    
    // NSData Conversion Variables
    var imageFrontNSData: NSData { return RCT_ImageController.imageToData(self.imageFrontUIImage)! }
    var imageBackNSData: NSData { return RCT_ImageController.imageToData(self.imageBackUIImage)! }
    
    let layout: Layout
    
    convenience init(imageFront: NSData, imageBack: NSData, layout: Layout = Layout.topBottom) {
        
        let UIImageFront = RCT_ImageController.dataToImage(imageFront)!
        let UIImageBack = RCT_ImageController.dataToImage(imageBack)!
        
        self.init(imageFrontCIImage: CIImage(image: UIImageFront)!, imageBackCIImage: CIImage(image: UIImageBack)!, layout: layout)
    }
    
    init(imageFrontCIImage: CIImage, imageBackCIImage: CIImage, layout: Layout = Layout.topBottom) {
    
        self.imageFrontCIImage = imageFrontCIImage
        self.imageBackCIImage = imageBackCIImage
    
        self.originalImageFrontCIImage = imageFrontCIImage.copy() as! CIImage
        self.originalImageBackCIImage = imageBackCIImage.copy() as! CIImage
        
        self.layout = layout

    }
    
    convenience init(image: RCT_Image) {
        
        self.init(imageFrontCIImage: image.imageFrontCIImage.copy() as! CIImage , imageBackCIImage: image.imageBackCIImage.copy() as! CIImage, layout: image.layout)
        
    }
    
}