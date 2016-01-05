//
//  ContainerViewController.swift
//  Reacture
//
//  Created by Skyler Tanner on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

class RCT_ContainerViewController: UIViewController {
    
    
    
    
}


extension RCT_ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OptionItemCell", forIndexPath: indexPath) as! RCT_OptionItemCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
}
