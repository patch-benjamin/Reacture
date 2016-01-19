//
//  PanGestureView.swift
//  Reacture
//
//  Created by Andrew Porter on 1/13/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

protocol PanGestureViewProtocol {
    
    func panDetected(center: CGPoint)
}

class PanGestureView: ZoomableView {
    
    var lastLocation: CGPoint = CGPointMake(0.0, 0.0)
    var isMoveableView: UIView?
    var delegate: PanGestureViewProtocol?
    
    func toggleIsMoveable() {
        
        if isMoveableView == nil {
            
            let view = UIView(frame: self.bounds)
            let imageView = UIImageView(image: UIImage(named: "move_arrows")!)
            imageView.contentMode = .ScaleAspectFill
            view.addSubview(imageView)
            imageView.frame = CGRectMake(view.bounds.width/4, view.bounds.height/4, view.bounds.width/2, view.bounds.height/2)
            view.backgroundColor = UIColor.whiteColor()
            view.alpha = 0.2
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "detectPan:"))
            isMoveableView = view
            self.addSubview(isMoveableView!)
            
        } else {
            
            self.isMoveableView!.removeFromSuperview()
            self.isMoveableView = nil
        }
    }
    
    func removeIsMovableView() {
        
        if isMoveableView != nil {
            
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
