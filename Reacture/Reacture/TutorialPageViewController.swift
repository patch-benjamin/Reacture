//
//  TutorialPageViewController.swift
//  Reacture
//
//  Created by Skyler Tanner on 1/19/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageViewController = UIPageViewController()
    let pageImages = ["onboard1", "onboard2", "onboard3", "onboard4", "onboard7"]
    let pageTitles = ["Snap a Selfie", "Opposite Camera Snaps Too", "Select a Layout, Long-Press on PIP to Move", "Apply a Filter", "Share!"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create page view controller
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self;
        
        let startingViewController = self.getItemController(0)
        let viewControllers = startingViewController
        self.pageViewController.setViewControllers([viewControllers!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        // Do any additional setup after loading the view.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageContentViewController
        
        if itemController.pageIndex! > 0 {
            return getItemController(itemController.pageIndex!-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageContentViewController
        
        if itemController.pageIndex!+1 < pageImages.count {
            return getItemController(itemController.pageIndex!+1)
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                itemController.skipIntroButton.alpha = 0
                itemController.skipIntroButton.setTitle("Done", forState: UIControlState.Normal)
                itemController.skipIntroButton.alpha = 1
            })
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageContentViewController? {
        
        if itemIndex < pageImages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
            pageItemController.pageIndex = itemIndex
            pageItemController.imageFile = self.pageImages[itemIndex]
            pageItemController.titleText = self.pageTitles[itemIndex]
            
            return pageItemController
        }
        
        return nil
    }
 
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
   
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
