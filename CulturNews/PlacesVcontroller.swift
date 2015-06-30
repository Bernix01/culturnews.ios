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
        
        self.title = "Establecimientos"
        
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        var heightNavfasd = self.navigationController?.navigationBar.frame.size.height
        var controller2 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 11, nheight: heightNavfasd!, parent: self)
        controller2.title = "TEATRO"
        controllerArray.append(controller2)
        var controller3 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 12, nheight: heightNavfasd!, parent: self)
        controller3.title = "MÚSICA CONTEMPORÁNEA"
        controllerArray.append(controller3)
        
        var controller4 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 13, nheight: heightNavfasd!, parent: self)
        controller4.title = "ESPACIOS CULTURALES"
        controllerArray.append(controller4)
    
        var controller5 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 14, nheight: heightNavfasd!, parent: self)
        controller5.title = "DANZA"
        controllerArray.append(controller5)
        
        var controller6 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 15, nheight: heightNavfasd!, parent: self)
        controller6.title = "MÚSICA CLÁSICA"
        controllerArray.append(controller6)
        var controller7 : TestCollectionViewController = TestCollectionViewController(nibName: "TestCollectionViewController", bundle: nil, catid: 16, nheight: heightNavfasd!, parent: self)
        controller7.title = "PINTURA"
        controllerArray.append(controller7)
        
        // Customize menu (Optional)
        var parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor(rgba: "#FFF")),
            .BottomMenuHairlineColor(UIColor(rgba: "#272726")),
            .UnselectedMenuItemLabelColor(UIColor(rgba: "#F0F0F0")),
            .SelectedMenuItemLabelColor(UIColor(rgba: "#FFF")),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 10.0)!),
            .MenuHeight(40),
            .MenuItemWidthBasedOnTitleTextWidth(true),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    func goTo(secondViewController: DetailVController){
        self.showViewController(secondViewController, sender: secondViewController)
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