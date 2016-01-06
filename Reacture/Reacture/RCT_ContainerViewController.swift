//
//  ContainerViewController.swift
//  Reacture
//
//  Created by Skyler Tanner on 1/5/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

var kIsLayoutSelected: Bool? = false

class RCT_ContainerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var itemCount: Int = 0
    var arrayOfItems: [AnyObject] = []
    var arrayOfLayoutTitles: [String] = ["Top & Bottom", "Side to Side", "Diagonal", "Picture in Picture"]
    var arrayOfFilterTitles: [String] = ["None", "Sepia", "B&W", "Tinted", "Modern", "Rebel", "Water"]

    override func viewDidLoad() {
        setupCollectionView()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "handleReloadCollectionNotification", name: "reloadCollectionView", object: nil)
    }

    func handleReloadCollectionNotification() {
        print("Collection View Reloaded")
        collectionView.reloadData()
    }

    func setupCollectionView() {
        if kIsLayoutSelected == true {
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
        if kIsLayoutSelected == true {
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
        if kIsLayoutSelected == true {
            self.itemCount = self.arrayOfLayoutTitles.count
        } else {
            // Filter Selected
            self.itemCount = self.arrayOfFilterTitles.count
        }
        return self.itemCount
    }
}