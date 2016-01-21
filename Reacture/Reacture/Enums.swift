//
//  Enums.swift
//  FlipPic
//
//  Created by Benjamin Patch on 1/6/16. Amended by Eric Mead & Paul Adams on 1/13/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import UIKit

enum OptionType: Int {
    case None = 0,
    Filters,
    Layout
}

enum Layout: Int {

    case PictureInPicture = 0,
    LeftRight,
    TopBottom,
    UpperLeftLowerRight,
    UpperRightLowerLeft,
    Count
}

let layoutIcons = [UIImage(named: "layout_southeast"),
    UIImage(named: "layout_side"),
    UIImage(named: "layout_top"),
    UIImage(named: "layout_diagonal_downright"),
    UIImage(named: "layout_diagonal_downleft")]

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