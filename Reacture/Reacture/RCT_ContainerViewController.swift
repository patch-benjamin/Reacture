//
//  ContainerViewController.swift
//  Reacture
//
//  Created by Eric Mead & Paul Adams on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

import UIKit

var kIsLayoutSelected: Bool? = true

protocol RCT_ContainerViewControllerProtocol {
    func itemSelected(indexPath: NSIndexPath)
}

class RCT_ContainerViewController: UIViewController {

    var selectedFrameZero: CGRect?
    var layoutSelected: CGFloat = 0.0
    var filterSelected: CGFloat = 0.0
    let borderWidth: CGFloat = 2.0
//    var selectedBox = UIView()

    @IBOutlet weak var collectionView: UICollectionView!

    // Filter Button Images
    var arrayOfFilterButtonImageViews: [UIImageView] = []

    var delegate: RCT_ContainerViewControllerProtocol?

    override func viewDidLoad() {

        setupCollectionView()
        //setupSelectedBox()
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
               print("Collection View Reloaded")
        //        if kIsLayoutSelected == true {
        //            self.itemCount = Layout.count.rawValue
        //        } else {
        //            // Filter Selected
        //            self.itemCount = Filter.count.rawValue
        //        }
        collectionView.reloadData()

        if kIsLayoutSelected == true {
             // it is layout
            // if there is already a selection:
//            if let frame = selectedFrameLayout {
//                selectedBox.frame = frame
//            } else {
//                // set to cell at index zero
//                if let frame = selectedFrameZero {
//                    selectedBox.frame = selectedFrameZero!
//                }
//            }

            collectionView.selectItemAtIndexPath(NSIndexPath(forItem: Int(layoutSelected), inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)

        } else {
//            // it is filter
//            // if there is already a selection:
//            if let frame = selectedFrameFilter {
//                selectedBox.frame = frame
//            } else {
//                // set to cell at index zero
//                if let frame = selectedFrameZero {
//                    selectedBox.frame = selectedFrameZero!
//                }
//
//            }

            collectionView.selectItemAtIndexPath(NSIndexPath(forItem: Int(filterSelected), inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        }
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

//        cell.layer.cornerRadius = 3.8
//        cell.layer.borderColor = UIColor.blackColor().CGColor
//        cell.layer.borderWidth = 0.0

//        if indexPath.item == 0 && selectedFrameZero == nil {
//            let frame1 = cell.frame
//            let frame = CGRect(x: (frame1.origin.x) - 3, y: (frame1.origin.y) - 3, width: (frame1.width) + 6, height: (frame1.height) + 6)
//            selectedFrameZero = frame
//            setupSelectedBox()
//        }
//

        if kIsLayoutSelected == true {

            if CGFloat(indexPath.item) == layoutSelected {
                cell.imageView.layer.borderWidth = borderWidth
                cell.imageView.layer.borderColor = UIColor.blueColor().CGColor

            } else {
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor.blueColor().CGColor
            }

            cell.label.hidden = true
            cell.label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            cell.imageView.backgroundColor = UIColor.whiteColor()
            
            cell.imageView.image = layoutIcons[indexPath.item]

        } else {
            // Filter Selected
//            cell.label.textColor = UIColor.whiteColor()
//            cell.label.font = UIFont.systemFontOfSize(18, weight: 1)

            if CGFloat(indexPath.item) == filterSelected {
                cell.imageView.layer.borderWidth = borderWidth
                cell.imageView.layer.borderColor = UIColor.blueColor().CGColor

            } else {
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor.blueColor().CGColor
            }

            cell.label.hidden = false
            cell.label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
//            cell.label.frame.size.width = cell.frame.size.width
            let labelText = String(Filter(rawValue: indexPath.item)!)
            cell.label.text = labelText
            // Setting Images for Filter Buttons
            if self.arrayOfFilterButtonImageViews.count == Filter.Count.rawValue {
                let imageView = arrayOfFilterButtonImageViews[indexPath.item]
                let image = imageView.image
                cell.imageView.image = image
                cell.imageView.contentMode = .ScaleAspectFill
            }
        }
//        self.collectionView.sendSubviewToBack(selectedBox)

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

//    func setupSelectedBox() {
//        selectedBox.backgroundColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1) // Hex #F85927
//        selectedBox.frame = CGRect (x: 0, y: 0, width: 0, height: 0)
//        if let frame = selectedFrameZero {
//            selectedBox.frame = frame
//        }
//        selectedBox.layer.cornerRadius = 3.8
//
//        collectionView.addSubview(selectedBox)
//        collectionView.sendSubviewToBack(selectedBox)
//    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

//        let frame1 = collectionView.cellForItemAtIndexPath(indexPath)?.frame
//        let frame = CGRect(x: (frame1?.origin.x)! - 3, y: (frame1?.origin.y)! - 3, width: (frame1?.width)! + 6, height: (frame1?.height)! + 6)
//
//        if kIsLayoutSelected == true {
//            // layout selected
//            self.selectedFrameLayout = frame
//            self.selectedBox.frame = self.selectedFrameLayout!
//        } else {
//            // filter selected
//            self.selectedFrameFilter = frame
//            self.selectedBox.frame = self.selectedFrameFilter!
//        }
//
//        self.collectionView.sendSubviewToBack(self.selectedBox)

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! RCT_OptionItemCollectionViewCell

        cell.imageView.layer.borderWidth = borderWidth
        cell.imageView.layer.borderColor = UIColor.blueColor().CGColor

        if kIsLayoutSelected != nil && kIsLayoutSelected! {
            layoutSelected = CGFloat(indexPath.item)

        } else {
            filterSelected = CGFloat(indexPath.item)
        }

        delegate?.itemSelected(indexPath)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! RCT_OptionItemCollectionViewCell

        cell.imageView.layer.borderWidth = 0
        cell.imageView.layer.borderColor = UIColor.blueColor().CGColor

    }
}