//
//  RCT_Image.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import Foundation

enum Layout: Int {
    case leftRight = 0,
    topBottom,
    topRightBottomLeft,
    pictureInPicture
}

class RCT_Image {
    
    let imageFront: NSData // Front is faceTime Camera
    let imageBack: NSData // Back is the larger, main Camera
    let layout: Layout
    
    init(imageFront: NSData, imageBack: NSData, layout: Layout = Layout.topBottom) {
        
        self.imageFront = imageFront
        self.imageBack = imageBack
        self.layout = layout

    }
    
    convenience init(image: RCT_Image) {
        
        self.init(imageFront: image.imageFront.copy() as! NSData, imageBack: image.imageBack.copy() as! NSData, layout: image.layout)
        
    }
    
}