//
//  PlacesVcontroller.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/26/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit

class PlacesVcontroller: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = "PAGE MENU"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToLeft")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToRight")
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        var controller2 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 11)
        controller2.title = "TEATRO"
        controllerArray.append(controller2)
        var controller3 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 12)
        controller3.title = "MÚSICA CONTEMPORÁNEA"
        controllerArray.append(controller3)
        
        var controller4 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 13)
        controller4.title = "ESPACIOS CULTURALES"
        controllerArray.append(controller4)
    
        var controller5 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 14)
        controller5.title = "DANZA"
        controllerArray.append(controller5)
        
        var controller6 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 15)
        controller6.title = "MÚSICA CLÁSICA"
        controllerArray.append(controller6)
        var controller7 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 16)
        controller7.title = "PINTURA"
        controllerArray.append(controller7)
        
        // Customize menu (Optional)
        var parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor.orangeColor()),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
    func didTapGoToLeft() {
        var currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        var currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
}