//
//  ScrollViewExtension.swift
//  Reacture
//
//  Created by Benjamin Patch on 1/15/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    /** The private viariable "contentOffset" of the ScrollView made accessible/public. */
    var getContentOffset: CGPoint {
        return self.contentOffset
    }    
}
