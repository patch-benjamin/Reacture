//
//  ImageController.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

class RCT_ImageController {
    
    
    // MARK: Create 
    
    static func createRCTImage(imageFront: NSData, imageBack: NSData, layout: Layout = Layout.topBottom) -> RCT_Image {
        
        let image = RCT_Image(imageFront: imageFront, imageBack: imageBack, layout: layout)
        
        return image
    }
    
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
    
    
    // MARK: Read
    
    
    
    // MARK: Update
    
    
    
    // MARK: Delete
    
    
}