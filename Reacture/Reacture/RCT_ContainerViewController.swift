//
//  ContainerViewController.swift
//  Reacture
//
//  Created by Eric Mead & Paul Adams on 1/5/16.
//  Copyright © 2016 BAEP. All rights reserved.
//

//switch optionSelected {
//case .Layout:
//    break
//case .Filters:
//    break
//}
// REACture


import UIKit

protocol RCT_ContainerViewControllerProtocol {
    func itemSelected(indexPath: NSIndexPath, optionSelected: OptionType)
}

class RCT_ContainerViewController: UIViewController {

    var optionSelected: OptionType = OptionType(rawValue: 0)!
    var selectedFrameZero: CGRect?
    var layoutSelected: Int = 0
    var filterSelected: Int = 0
    let borderWidth: CGFloat = 2.0
//    var selectedBox = UIView()

    @IBOutlet weak var collectionView: UICollectionView!

    // Filter Button Images
    var arrayOfFilterButtonImageViews: [UIImageView] = []

    var delegate: RCT_ContainerViewControllerProtocol?

    override func viewDidLoad() {

        setupCollectionView()
        //setupSelectedBox()

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
            
        }
        
    }

    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)
        
        switch optionSelected {
        case .Layout:
            print("Layout is Selected, Present Layout Options")
        case .Filters:
            print("Filter is Selected, Present Filter Options")
        }

    }
}

extension RCT_ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OptionItemCell", forIndexPath: indexPath) as! RCT_OptionItemCollectionViewCell

        switch optionSelected {
        case .Layout:

            if indexPath.item == layoutSelected {
                cell.imageView.layer.borderWidth = borderWidth
                cell.imageView.layer.borderColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1).CGColor // Hex #F85927
                
            } else {
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1).CGColor // Hex #F85927
            }
            
            cell.imageView.backgroundColor = UIColor.lightGrayColor()
            cell.label.text = ""
            cell.label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
            cell.imageView.backgroundColor = UIColor.whiteColor()
            
            cell.imageView.image = layoutIcons[indexPath.item]

        case .Filters:

            if indexPath.item == filterSelected {
                cell.imageView.layer.borderWidth = borderWidth
                cell.imageView.layer.borderColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1).CGColor // Hex #F85927
                
            } else {
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1).CGColor // Hex #F85927
            }
            
            cell.label.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
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
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch optionSelected {
        case .Layout:

            return Layout.Count.rawValue

        case .Filters:

            return Filter.Count.rawValue

        }

    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! RCT_OptionItemCollectionViewCell

        cell.imageView.layer.borderWidth = borderWidth
        cell.imageView.layer.borderColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1).CGColor // Hex #F85927

        switch optionSelected {
        case .Layout:
           
            layoutSelected = indexPath.item

        case .Filters:
            
            filterSelected = indexPath.item

        }

        delegate?.itemSelected(indexPath, optionSelected: optionSelected)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? RCT_OptionItemCollectionViewCell {

            
            switch optionSelected {
            case .Layout:
                
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1).CGColor // Hex #F85927
                
                layoutSelected = indexPath.item
                
            case .Filters:
                
                cell.imageView.layer.borderWidth = 0
                cell.imageView.layer.borderColor = UIColor(red: 248/255, green: 89/255, blue: 39/255, alpha: 1).CGColor // Hex #F85927
                
                filterSelected = indexPath.item
                
            }
        }
    }
    
}