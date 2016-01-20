//
//  ZoomableView.swift
//  FlipPic
//
//  Created by Benjamin Patch on 1/15/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import UIKit

class ZoomableView: UIView {

    //////////////////////////////
    // MARK: Variables
    //////////////////////////////

    private var shapeLayer = CAShapeLayer()

    var maskLayout: MaskLayout = MaskLayout.None {
        didSet {
            setNeedsLayout()
        }
    }

    var scrollView: UIScrollView!

    //////////////////////////////
    // MARK: Functions
    //////////////////////////////

    override func layoutSubviews() {
        super.layoutSubviews()
        updateShape()
    }

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        // Specify if a touch should be considered valid
        // Not valid if in the mask area.
        if RCT_LayoutController.isCornersLayout {
            return CGPathContainsPoint(shapeLayer.path, nil, layer.convertPoint(point, fromLayer: shapeLayer), false)
        } else {
            return super.pointInside(point, withEvent: event)
        }
    }

    private func updateShape() {

        layer.mask = nil

        if let pathLayout = pathForLayout(maskLayout) {
            let path = pathLayout.CGPath
            shapeLayer.frame = self.frame
            shapeLayer.path = path
            layer.mask = shapeLayer
        }
    }

    private func pathForLayout(maskLayout: MaskLayout) -> UIBezierPath? {

        var path: UIBezierPath! = UIBezierPath()

        let layerHeight = self.bounds.height
        let layerWidth = self.bounds.width

        let topRightPoint = CGPointMake(layerWidth, 0)
        let topLeftPoint = CGPointMake(0, 0)
        let bottomRightPoint = CGPointMake(layerWidth, layerHeight)
        let bottomLeftPoint = CGPointMake(0, layerHeight)

        print("test: Layout: \(maskLayout) selected")

        switch maskLayout {

        case .None:
            path = nil

        case .TopRight:

            path.moveToPoint(bottomRightPoint)
            path.addLineToPoint(topRightPoint)
            path.addLineToPoint(topLeftPoint)
            path.addLineToPoint(bottomRightPoint)

        case .BottomLeft:

            path.moveToPoint(bottomRightPoint)
            path.addLineToPoint(bottomLeftPoint)
            path.addLineToPoint(topLeftPoint)
            path.addLineToPoint(bottomRightPoint)

        case .TopLeft:

            path.moveToPoint(bottomLeftPoint)
            path.addLineToPoint(topLeftPoint)
            path.addLineToPoint(topRightPoint)
            path.addLineToPoint(bottomLeftPoint)

        case .BottomRight:

            path.moveToPoint(bottomLeftPoint)
            path.addLineToPoint(bottomRightPoint)
            path.addLineToPoint(topRightPoint)
            path.addLineToPoint(bottomLeftPoint)
        }
        return path
    }
}
