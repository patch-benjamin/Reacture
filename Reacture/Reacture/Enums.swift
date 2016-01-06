//
//  Enums.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/6/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import Foundation

enum Layout: Int {

    case leftRight = 0,
    topBottom,
    topRightBottomLeft,
    pictureInPicture

}

enum Filter: Int {
    
    case none = 0,
    mono,
    tonal,
    noir,
    fade,
    chrome,
    process,
    transfer,
    instant,
    count
    
}
