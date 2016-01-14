//
//  Enums.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/6/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import Foundation

enum Layout: Int {
    
    case LeftRight = 0,
    TopBottom,
    PictureInPicture,
    Count
    
}

enum MaskLayout: Int {
    case None = 0,
    TopRight,
    BottomLeft,
    TopLeft,
    BottomRight,
    Top,
    Bottom,
    Left,
    Right,
    SmallPictureBottomRight,
    SmallPictureBottomLeft,
    SmallPictureTopRight,
    SmallPictureTopLeft
}

enum Filter: Int {
    
    case None = 0,
    Mono,
    Tonal,
    Noir,
    Fade,
    Chrome,
    Process,
    Transfer,
    Instant,
    Count
    
}
