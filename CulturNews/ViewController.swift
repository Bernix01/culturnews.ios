//
//  ViewController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/23/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var selectedIndex = 0
    private var transitionPoint: CGPoint!
    private var contentType: ContentType = .Music
    private var navigator: UINavigationController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier, segue.destinationViewController) {
        case (.Some("presentMenu"), let menu as MenuViewController):
            menu.selectedItem = selectedIndex
            menu.delegate = self
        case (.Some("embedNavigator"), let navigator as UINavigationController):
            self.navigator = navigator
            self.navigator.delegate = self
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }
}
extension ViewController: MenuViewControllerDelegate {
    func menu(_: MenuViewController, didSelectItemAtIndex index: Int, atPoint point: CGPoint) {
        contentType = !contentType
        transitionPoint = point
        selectedIndex = index
        switch(selectedIndex){
            case (0):
                navigationItem.title = "sdfsdf"
                let content = storyboard!.instantiateViewControllerWithIdentifier("Events") as! EventsViewController
                self.navigator.setViewControllers([content], animated: true)
                self.navigator.title = "Eventos"
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)

            }
        case(1):
            navigationItem.title = "sdfsasdasdasdf"
                    let content = storyboard!.instantiateViewControllerWithIdentifier("News") as! NewsViewController
                    self.navigator.setViewControllers([content], animated: true)
                    self.navigator.title = "Noticias"
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dismissViewControllerAnimated(true, completion: nil)
            }
        case(2):
            let content = storyboard!.instantiateViewControllerWithIdentifier("Places") as! PlacesVcontroller
            self.navigator.setViewControllers([content], animated: true)
            self.navigator.title = "Estableciemientos"
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
                        default:
                            
                            let content = storyboard!.instantiateViewControllerWithIdentifier("Content") as! ContentViewController
                            content.type = contentType
                            self.navigator.setViewControllers([content], animated: true)
                            
                            dispatch_async(dispatch_get_main_queue()) {
                            }
                            self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
    }
    
    func menuDidCancel(_: MenuViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController, animationControllerForOperation _: UINavigationControllerOperation,
        fromViewController _: UIViewController, toViewController _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            return CircularRevealTransitionAnimator(center: transitionPoint)
    }
}
extension UIColor {
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = advance(rgba.startIndex, 1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (count(hex)) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                println("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}


