//
//  ContainerViewController.swift
//  Reacture
//
//  Created by Eric Mead on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

var kIsLayoutSelected: Bool? = false

protocol RCT_ContainerViewControllerProtocol {
    func itemSelected(indexPath: NSIndexPath)
}

class RCT_ContainerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var itemCount: Int = 0
    var arrayOfItems: [AnyObject] = []
    var arrayOfLayoutTitles: [String] = ["Corner", "Top", "Side", "Diagonal", "Center"]
    var arrayOfFilterTitles: [String] = ["None", "Retro", "Water", "Sepia", "Blue", "B&W", "Mono"]
    var delegate: RCT_ContainerViewControllerProtocol?

    override func viewDidLoad() {
        setupCollectionView()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "handleReloadCollectionNotification", name: "reloadCollectionView", object: nil)
    }

    func handleReloadCollectionNotification() {
        print("Collection View Reloaded")
        if kIsLayoutSelected == true {
            self.itemCount = self.arrayOfLayoutTitles.count
        } else {
            // Filter Selected
            self.itemCount = self.arrayOfFilterTitles.count
        }
        collectionView.reloadData()
    }

    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
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
            cell.imageView.backgroundColor = UIColor.whiteColor()
        } else {
            // Filter Selected
            cell.label.text = self.arrayOfFilterTitles[indexPath.item]
            cell.imageView.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if kIsLayoutSelected == true {
        //            self.itemCount = self.arrayOfLayoutTitles.count
        //        } else {
        //            // Filter Selected
        //            self.itemCount = self.arrayOfFilterTitles.count
        //        }
        return self.itemCount
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let indexPath = indexPath.item
        delegate?.itemSelected(indexPath)

        //        if kIsLayoutSelected == true {
        //            print("\(arrayOfLayoutTitles[indexPath]) was Selected")
        //            handleItemTapped(arrayOfLayoutTitles[indexPath])
        //        } else {
        //            // Filter Selected
        //            print("\(arrayOfFilterTitles[indexPath]) was Selected")
        //            handleItemTapped(arrayOfFilterTitles[indexPath])
        //        }
    }

    func handleItemTapped(title: String) {
        //["Top & Bottom", "Side to Side", "Diagonal", "Picture in Picture", "Center"]

        //Layout Item Options:
        if title == "Top & Bottom" {
            print("perform \(title) functions here")
        }
        if title == "Side to Side" {
            print("perform \(title) functions here")        }
        if title == "Diagonal" {
            print("perform \(title) functions here")
        }
        if title == "Picture in Picture" {
            print("perform \(title) functions here")
        }
        if title == "Center" {
            print("perform \(title) functions here")
        }

        //Filter Item Options:
        if title == "Sepia" {
            print("perform \(title) functions here")
        }
        if title == "B&W" {
            print("perform \(title) functions here")
        }
    }
}