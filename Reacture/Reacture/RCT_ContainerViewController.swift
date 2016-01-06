//
//  ContainerViewController.swift
//  Reacture
//
//  Created by Skyler Tanner on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

class RCT_ContainerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var isLayoutSelected: Bool? = false
    var itemCount: Int = 0
    var arrayOfItems: [AnyObject] = []
    var arrayOfLayoutTitles: [String] = ["Top Bottom", "Side Side", "Diagonal", "Picture in Picture"]
    var arrayOfFilterTitles: [String] = ["None", "Sepia", "B&W", "Tinted", "Modern", "Rebel", "Water"]

    override func viewDidLoad() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        if isLayoutSelected == true {
            print("Layout is Selected, Present Layout Options")
            self.itemCount = self.arrayOfLayoutTitles.count
        } else {
            print("Filter is Selected, Present Filter Options")
            self.itemCount = self.arrayOfFilterTitles.count
        }
    }
}

extension RCT_ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OptionItemCell", forIndexPath: indexPath) as! RCT_OptionItemCollectionViewCell
        if isLayoutSelected == true {
            cell.label.text = arrayOfLayoutTitles[indexPath.item]
            cell.imageView.backgroundColor = UIColor.blueColor()
        } else {
            // Filter Selected
            cell.label.text = self.arrayOfFilterTitles[indexPath.item]
            cell.imageView.backgroundColor = UIColor.yellowColor()

        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCount
    }
    
}
