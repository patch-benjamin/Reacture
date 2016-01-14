//
//  ContainerViewController.swift
//  Reacture
//
//  Created by Eric Mead on 1/5/16. Amended by Paul Adams on 1/14/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

var kIsLayoutSelected: Bool? = true

protocol RCT_ContainerViewControllerProtocol {
    func itemSelected(indexPath: NSIndexPath)
}

class RCT_ContainerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    // Filter Button Images
    var arrayOfFilterButtonImageViews: [UIImageView] = []

    var delegate: RCT_ContainerViewControllerProtocol?

    override func viewDidLoad() {
        setupCollectionView()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "handleReloadCollectionNotification", name: "reloadCollectionView", object: nil)
        nc.addObserver(self, selector: "handleFilterButtonImagesNotification:", name: "Filter Button Images Complete", object: nil)
    }

    func handleFilterButtonImagesNotification(notification: NSNotification) {
        print("Handling Filter Button Images")
        if let userInfo = notification.userInfo {
            let arrayOfImageViews = userInfo["filterButtonImageViews"]
            self.arrayOfFilterButtonImageViews = arrayOfImageViews as! [UIImageView]
            self.collectionView.reloadData()
            print("Reloading Collection View")
        }
    }

    func handleReloadCollectionNotification() {
        //        print("Collection View Reloaded")
        //        if kIsLayoutSelected == true {
        //            self.itemCount = Layout.count.rawValue
        //        } else {
        //            // Filter Selected
        //            self.itemCount = Filter.count.rawValue
        //        }
        collectionView.reloadData()
    }

    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)
        if kIsLayoutSelected == true {
            print("Layout is Selected, Present Layout Options")
            //            self.itemCount = self.arrayOfLayoutTitles.count
        } else {
            print("Filter is Selected, Present Filter Options")
            //            self.itemCount = self.arrayOfFilterTitles.count
        }
    }
}

extension RCT_ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OptionItemCell", forIndexPath: indexPath) as! RCT_OptionItemCollectionViewCell

        cell.layer.cornerRadius = 7.5
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 2.0

        if kIsLayoutSelected == true {
            //            cell.label.text = String(Layout(rawValue: indexPath.item)!)
            cell.label.text = ""
            cell.label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            cell.imageView.backgroundColor = UIColor.whiteColor()
            let array: [UIImage] = [UIImage(named: "layout_top")!, UIImage(named: "layout_side")!, UIImage(named: "layout_southeast")!]
            cell.imageView.image = array[indexPath.item]

        } else {
            // Filter Selected
            cell.label.translatesAutoresizingMaskIntoConstraints = true
            cell.label.textColor = UIColor.whiteColor()
            cell.label.font = UIFont.systemFontOfSize(18, weight: 5)
            cell.label.frame.origin = CGPoint(x: 0, y: cell.frame.size.height - cell.label.frame.size.height - 2.5)
            cell.label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            cell.label.frame.size.width = cell.frame.size.width
            let labelText = String(Filter(rawValue: indexPath.item)!)
            cell.label.text = labelText.capitalizedString
            cell.imageView.backgroundColor = UIColor.blackColor()
            // Setting Images for Filter Buttons
            if self.arrayOfFilterButtonImageViews.count == Filter.Count.rawValue {
                let imageView = arrayOfFilterButtonImageViews[indexPath.item]
                let image = imageView.image
                cell.imageView.image = image
            }
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if kIsLayoutSelected == true {
            return Layout.Count.rawValue
        } else {
            // Filter Selected
            return Filter.Count.rawValue
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.itemSelected(indexPath)
    }
}