//
//  Enums.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/6/16. Amended by Eric Mead & Paul Adams on 1/13/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

enum Layout: Int {
    
    case TopBottom = 0,
    LeftRight,
    UpperLeftLowerRight,
    UpperRightLowerLeft,
    PictureInPicture,
    Count
}

let layoutIcons = [UIImage(named: "top_bottom"),
    UIImage(named: "left_right"),
    UIImage(named: "top_left_bottom_right"),
    UIImage(named: "top_right_bottom_left"),
    UIImage(named: "picture_in_picture")]

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