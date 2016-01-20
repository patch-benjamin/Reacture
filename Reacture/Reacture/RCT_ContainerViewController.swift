//
//  ContainerViewController.swift
//  FlipPic
//
//  Created by Eric Mead & Paul Adams on 1/5/16.
//  Copyright © 2016 BAEPS. All rights reserved.
//

import UIKit

protocol RCT_ContainerViewControllerProtocol {
    func itemSelected(indexPath: NSIndexPath, optionSelected: OptionType)
}

class RCT_ContainerViewController: UIViewController {

    var optionSelected: OptionType = OptionType(rawValue: 0)!
    var selectedFrameZero: CGRect?
    var layoutSelected: Int  = 0
    var filterSelected: Int  = 0
    let borderWidth: CGFloat = 2.0

    @IBOutlet weak var collectionView: UICollectionView!

    // Filter Button Images
    var arrayOfFilterButtonImageViews: [UIImageView] = []
    var delegate: RCT_ContainerViewControllerProtocol?
    override func viewDidLoad() {
        setupCollectionView()
    }

    func loadFilterButtonImages(arrayOfImageViews: [UIImageView]) {
        print("Handling Filter Button Images")
        self.arrayOfFilterButtonImageViews = arrayOfImageViews
        self.collectionView.reloadData()
        print("Reloading Collection View")
    }

    func reloadCollection() {
        print("Collection View Reloaded")

        collectionView.reloadData()

        switch optionSelected {
        case .Layout:

            collectionView.selectItemAtIndexPath(NSIndexPath(forItem: Int(layoutSelected), inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)

        case .Filters:
            collectionView.selectItemAtIndexPath(NSIndexPath(forItem: Int(filterSelected), inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
            
        case .None:
            break

        }
    }

    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.flipPicGray().colorWithAlphaComponent(1)

        switch optionSelected {
        case .Layout:
            print("Layout is Selected, Present Layout Options")
        case .Filters:
            print("Filter is Selected, Present Filter Options")
        case .None:
            print("None is selected. Hide stuff.")

        }
    }
}

extension RCT_ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OptionItemCell", forIndexPath: indexPath) as! RCT_OptionItemCollectionViewCell

        switch optionSelected {
        case .Layout:

            cell.imageView.backgroundColor = UIColor.whiteColor()
            if indexPath.item == layoutSelected {
                cell.imageView.layer.borderWidth = borderWidth
                cell.imageView.layer.borderColor = UIColor.flipPicGreen().CGColor
                cell.imageView.backgroundColor = UIColor.flipPicGreen()

            } else {
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor.flipPicGreen().CGColor
            }
            cell.label.hidden = true
            cell.imageView.image = layoutIcons[indexPath.item]

        case .Filters:
            
            cell.backgroundColor = UIColor.clearColor()
            cell.label.textColor = UIColor.whiteColor()
            cell.label.hidden = false
            
            if indexPath.item == filterSelected {
                cell.imageView.layer.borderWidth = borderWidth
                cell.imageView.layer.borderColor = UIColor.flipPicGreen().CGColor
                cell.label.textColor = UIColor.flipPicGreen()
            } else {
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor.flipPicGreen().CGColor
            }
            let labelText = String(Filter(rawValue: indexPath.item)!)
            cell.label.text = labelText
            // Setting Images for Filter Buttons
            if self.arrayOfFilterButtonImageViews.count == Filter.Count.rawValue {
                let imageView = arrayOfFilterButtonImageViews[indexPath.item]
                let image = imageView.image
                cell.imageView.image = image
                cell.imageView.contentMode = .ScaleAspectFill
            }
            
        case .None:
            break
            
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch optionSelected {
        case .Layout:
            return Layout.Count.rawValue
        case .Filters:
            return Filter.Count.rawValue
        case .None:
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! RCT_OptionItemCollectionViewCell

        cell.imageView.layer.borderWidth = borderWidth
        cell.imageView.layer.borderColor = UIColor.flipPicGreen().CGColor

        switch optionSelected {

        case .Layout:
            layoutSelected = indexPath.item
            cell.imageView.backgroundColor = UIColor.flipPicGreen()

        case .Filters:
            filterSelected = indexPath.item
            cell.label.textColor = UIColor.flipPicGreen()

        case .None:
            break

        }
        delegate?.itemSelected(indexPath, optionSelected: optionSelected)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? RCT_OptionItemCollectionViewCell {

            switch optionSelected {

            case .Layout:
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor.flipPicGreen().CGColor
                cell.imageView.backgroundColor = UIColor.whiteColor()
                layoutSelected = indexPath.item

            case .Filters:
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor.flipPicGreen().CGColor
                cell.label.textColor = UIColor.whiteColor()
                filterSelected = indexPath.item

            case .None:
                break

            }
        }
    }
}