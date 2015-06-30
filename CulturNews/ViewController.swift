//
//  ViewController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/23/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    private var selectedIndex = 0
    let picker = UIView()
    struct properties {
        static let moods = [
            ["title" : "Contacto", "color" : "#8647b7", "url":"http://culturnews.com/index.php/contactenos"],
            ["title" : "Sugerencias", "color": "#4870b7", "url": "http://culturnews.com/index.php/contactenos/sugerencias"],
        ]
    }
    private var transitionPoint: CGPoint!
    private var contentType: ContentType = .Music
    private var navigator: UINavigationController!
    @IBOutlet weak var menubutton: UIButton!
    @IBAction func menu(sender: AnyObject) {
        picker.hidden ? openPicker() : closePicker()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.backgroundColor = UIColor(rgba: "#272726")
        createPicker()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let popupView = segue.destinationViewController as? UIViewController
        {
            if let popup = popupView.popoverPresentationController
            {
                popup.delegate = self
            }
        }
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
    func createPicker()
    {
    picker.frame = CGRect(x: self.view.frame.width-125 , y: 70, width: 120, height: 90)
    picker.alpha = 0
    picker.hidden = true
    picker.userInteractionEnabled = true
    
    var offset = 0
    
    for (index, feeling) in enumerate(properties.moods)
    {
    let button = UIButton()
    button.frame = CGRect(x: 0, y: offset, width: 120, height: 43)
    button.setTitleColor(UIColor(rgba: "#d5b480"), forState: .Normal)
    button.setTitle(feeling["title"], forState: .Normal)
        button.addTarget(self, action: "followButtonTapped:", forControlEvents: .TouchUpInside)
    button.tag = index
    
    picker.addSubview(button)
    
    offset += 44
    }
    
    view.addSubview(picker)
    }
    
    func openPicker()
    {
        self.picker.hidden = false
        
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: (self.view.frame.width-125), y: 70, width: 120, height: 90)
                self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: self.view.frame.width/2, y: 70, width: 286, height: 200)
                self.picker.alpha = 0
            },
            completion: { finished in
                self.picker.hidden = true
            }
        )
    }
    
    func followButtonTapped(sender: UIButton) {
        let urlString = NSURL(string: (properties.moods[sender.tag]["url"])!)
        UIApplication.sharedApplication().openURL(urlString!)
        
    }
}
extension ViewController: MenuViewControllerDelegate {
    func menu(_: MenuViewController, didSelectItemAtIndex index: Int, atPoint point: CGPoint) {
        contentType = !contentType
        //self.navigator = self.window.rootViewController
        transitionPoint = point
        selectedIndex = index
        switch(selectedIndex){
            case (0):
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
        fromViewController frtomVw: UIViewController, toViewController nextView: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if nextView is DetailVController ||  frtomVw is DetailVController {
                println("poo")
                self.menubutton.hidden = !self.menubutton.hidden
            }
            if let center = transitionPoint {
                println("bar")
                return CircularRevealTransitionAnimator(center: transitionPoint)
            }else{
                println("foo")
                return CircularRevealTransitionAnimator(center: CGPointMake(0, 0))
            }
            
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


