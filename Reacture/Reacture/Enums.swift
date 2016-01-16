//
//  Enums.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/6/16. Amended by Eric Mead on 1/13/16. Amended by Paul Adams on 1/13/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import Foundation

enum Layout: Int {
    
    case TopBottom = 0,
    LeftRight,
    UpperLeftLowerRight,
    UpperRightLowerLeft,
    PictureInPicture,
    Count
}

enum SubLayout: Int {
    
    case None = 0,
    Top,
    Bottom,
    Left,
    Right,
    TopRight,
    BottomRight,
    TopLeft,
    BottomLeft,
    BigPicture,
    LittlePicture
}

enum MaskLayout: Int {
    case None = 0,
    TopRight,
    BottomLeft,
    TopLeft,
    BottomRight
}

enum Filter: Int {
    case None = 0,
    Fade,
    Chrome,
    Poster,
    Comic,
    Tonal,
    Noir,
    Count
}