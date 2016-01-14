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
    Fade,
    Chrome,
    Poster,
    Comic,
    Tonal,
    Noir,
    Count
}