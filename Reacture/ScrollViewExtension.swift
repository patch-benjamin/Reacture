//
//  ScrollViewExtension.swift
//  FlipPic
//
//  Created by Benjamin Patch on 1/15/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import UIKit

extension UIScrollView {

    // The Private Variable "contentOffset" of the ScrollView Made Accessible/Public
    var getContentOffset: CGPoint {
        return self.contentOffset
    }
}
