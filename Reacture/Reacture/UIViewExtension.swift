//
//  UIViewExtension.swift
//  FlipPic
//
//  Created by Andrew Porter on 1/16/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import UIKit

extension UIView {

    private var littleLineWidthPercentage: CGFloat { return 0.5 }

    func leftBorder(littleImage: Bool = false) -> CALayer {

        var lineWidth = RCT_EditViewController.lineWidth
        if littleImage { lineWidth *= littleLineWidthPercentage }
        let layer = CALayer()
        layer.backgroundColor = UIColor.whiteColor().CGColor
        layer.frame = CGRectMake(0.0, 0.0, lineWidth, self.frame.height)

        return layer
    }

    func rightBorder(littleImage: Bool = false) -> CALayer {

        var lineWidth = RCT_EditViewController.lineWidth
        if littleImage { lineWidth *= littleLineWidthPercentage }
        let layer = CALayer()
        layer.backgroundColor = UIColor.whiteColor().CGColor
        layer.frame = CGRectMake(self.bounds.maxX - lineWidth, 0.0, lineWidth, self.bounds.height)

        return layer
    }

    func topBorder(littleImage: Bool = false) -> CALayer {

        var lineWidth = RCT_EditViewController.lineWidth
        if littleImage { lineWidth *= littleLineWidthPercentage }
        let layer = CALayer()
        layer.backgroundColor = UIColor.whiteColor().CGColor
        layer.frame = CGRectMake(0.0, 0.0, self.frame.width, lineWidth)

        return layer
    }

    func bottomBorder(littleImage: Bool = false) -> CALayer {

        var lineWidth = RCT_EditViewController.lineWidth
        if littleImage { lineWidth *= littleLineWidthPercentage }
        let layer = CALayer()
        layer.backgroundColor = UIColor.whiteColor().CGColor
        layer.frame = CGRectMake(0.0, self.bounds.maxY - lineWidth, self.bounds.width, lineWidth)

        return layer
    }

    private var topLeftToBottomRightBorder: CAShapeLayer {

        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0.0, 0.0))
        path.addLineToPoint(CGPointMake(self.bounds.maxX, self.bounds.maxY))
        layer.path = path.CGPath
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.lineWidth = RCT_EditViewController.lineWidth
        layer.fillColor = UIColor.clearColor().CGColor

        return layer
    }

    private var topRightToBottomLeftBorder: CAShapeLayer {

        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(self.bounds.maxX, 0.0))
        path.addLineToPoint(CGPointMake(0.0, self.bounds.maxY))
        layer.path = path.CGPath
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.lineWidth = RCT_EditViewController.lineWidth
        layer.fillColor = UIColor.clearColor().CGColor

        return layer
    }

    func removeBorders() {
        print("Before: \(layer.sublayers?.count)")

        if layer.sublayers?.count > 1 {
            var index = 0
            layer.sublayers?.forEach({ (layer) -> () in
                if index != 0 {
                    layer.removeFromSuperlayer()
                }
                index++
            })
        }

        print("After: \(layer.sublayers?.count)")

    }

    func updateBorderForLayout(layout: SubLayout) {


        print(layer.sublayers?.count)

        switch layout {

        case .Bottom:
            self.layer.addSublayer(leftBorder())
            self.layer.addSublayer(rightBorder())
            self.layer.addSublayer(bottomBorder())

        case .Top:
            self.layer.addSublayer(leftBorder())
            self.layer.addSublayer(rightBorder())
            self.layer.addSublayer(topBorder())

        case .Left:
            self.layer.addSublayer(leftBorder())
            self.layer.addSublayer(topBorder())
            self.layer.addSublayer(bottomBorder())

        case .Right:
            self.layer.addSublayer(rightBorder())
            self.layer.addSublayer(topBorder())
            self.layer.addSublayer(bottomBorder())

        case .TopRight:
            self.layer.addSublayer(topLeftToBottomRightBorder)

        case .BottomRight:
            self.layer.addSublayer(topRightToBottomLeftBorder)

        case .TopLeft:
            self.layer.addSublayer(topRightToBottomLeftBorder)

        case .BottomLeft:
            self.layer.addSublayer(topLeftToBottomRightBorder)

        case .BigPicture:
            self.layer.addSublayer(leftBorder())
            self.layer.addSublayer(topBorder())
            self.layer.addSublayer(bottomBorder())
            self.layer.addSublayer(rightBorder())

        case .LittlePicture:
            self.layer.addSublayer(leftBorder(true))
            self.layer.addSublayer(topBorder(true))
            self.layer.addSublayer(bottomBorder(true))
            self.layer.addSublayer(rightBorder(true))
        case .None:
            break
        }
    }
}
