//
//  RCT_Image.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
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
    var imageFrontUIImage: UIImage
    var imageBackUIImage: UIImage
    
    // NSData Conversion Variables
//    var imageFrontNSData: NSData { return RCT_ImageController.imageToData(self.imageFrontUIImage)! }
//    var imageBackNSData: NSData { return RCT_ImageController.imageToData(self.imageBackUIImage)! }
    
//    var imageFrontData: NSData
//    var imageBackData: NSData
    
    var layout: Layout
    
//    convenience init(imageFront: NSData, imageBack: NSData, layout: Layout = Layout.topBottom) {
//        
//        let UIImageFront = RCT_ImageController.dataToImage(imageFront)!
//        let UIImageBack = RCT_ImageController.dataToImage(imageBack)!
//        
//        self.init(imageFrontCIImage: CIImage(image: UIImageFront)!, imageBackCIImage: CIImage(image: UIImageBack)!, layout: layout)
//    }
    
//    init(imageFrontData: NSData, imageBackData: NSData, layout: Layout = Layout.topBottom) {
//        
//        self.imageFrontUIImage = imageFrontData
//        self.imageBackUIImage = imageBackData
//        
//        
//        self.imageFrontCIImage = CIImage(image: imageFrontData)!
//        self.imageBackCIImage = CIImage(image: imageBackData)!
//        
//        self.originalImageFrontCIImage = imageFrontCIImage.copy() as! CIImage
//        self.originalImageBackCIImage = imageBackCIImage.copy() as! CIImage
//        
//        self.layout = layout
//    }

    
    init(imageFront: UIImage, imageBack: UIImage, layout: Layout = Layout.TopBottom) {
        
        self.imageFrontUIImage = imageFront
        self.imageBackUIImage = imageBack


        self.imageFrontCIImage = CIImage(image: imageFront)!
        self.imageBackCIImage = CIImage(image: imageBack)!
        
        self.originalImageFrontCIImage = imageFrontCIImage.copy() as! CIImage
        self.originalImageBackCIImage = imageBackCIImage.copy() as! CIImage

        self.layout = layout
    }
    
//    init(imageFrontCIImage: CIImage, imageBackCIImage: CIImage, layout: Layout = Layout.topBottom) {
//    
//        self.imageFrontCIImage = imageFrontCIImage
//        self.imageBackCIImage = imageBackCIImage
//    
//        self.originalImageFrontCIImage = imageFrontCIImage.copy() as! CIImage
//        self.originalImageBackCIImage = imageBackCIImage.copy() as! CIImage
//        
//        
//        self.layout = layout
//
//    }
    
//    convenience init(image: RCT_Image) {
//        
//        self.init(imageFrontCIImage: image.imageFrontCIImage.copy() as! CIImage , imageBackCIImage: image.imageBackCIImage.copy() as! CIImage, layout: image.layout)
//        
//    }
    
}