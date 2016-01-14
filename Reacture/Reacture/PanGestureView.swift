//
//  PanGestureView.swift
//  Reacture
//
//  Created by Andrew Porter on 1/13/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

protocol PanGestureViewProtocol {
    
    func panDetected(center: CGPoint)
}

class PanGestureView: UIView {
    
    var lastLocation: CGPoint = CGPointMake(0.0, 0.0)
    var isMoveableView: UIView?
    var delegate: PanGestureViewProtocol?
    
    func toggleIsMoveable() {
        
        if isMoveableView == nil {
            
            let view = UIView(frame: self.bounds)
            view.backgroundColor = UIColor.orangeColor()
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "detectPan:"))
            isMoveableView = view
            self.addSubview(isMoveableView!)
            
        } else {
            
            self.isMoveableView!.removeFromSuperview()
            self.isMoveableView = nil
        }
    }
    
    func detectPan(recognizer: UIPanGestureRecognizer) {
        print("Pan detected")
        
             let translation = recognizer.translationInView(self.superview)
            self.delegate?.panDetected(CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y))
            print("Pan valid. Center = \(CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y))")

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touches began")
        print("center: \(self.center)")
        lastLocation = self.center
        
    }
    
}
