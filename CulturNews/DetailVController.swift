//
//  DetailVController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/27/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit

class DetailVController: UIViewController, UINavigationBarDelegate {
    
    
    
    @IBOutlet weak var titleTXT: UILabel!
    @IBOutlet weak var imgvw: UIImageView!
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    @IBOutlet weak var FNavHeight: NSLayoutConstraint!
    var imgurl: NSURL?
    var cnt: String?
    var titlestr: String?
    var wb: String = ""
    var fb: String = ""
    var tw: String = ""
    var ig: String = ""
    var isPlac: Bool = false
    var heightNav: CGFloat?
    var Socials: [socialItem] = []
    @IBOutlet weak var cntTXT: UITextView!
    @IBOutlet weak var HeaderVW: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("\(heightNav)")
        if(isPlac){
            self.FNavHeight.constant = heightNav!
            self.titleTXT.text = titlestr
        }else{
            HeaderVW.hidden = true
            self.FNavHeight.constant = 0
        }
        cntTXT.text = cnt
        imgvw.setImageWithURL(imgurl!, cacheScaled: true)
        
        self.title = titlestr
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
                // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
      switch (segue.identifier, segue.destinationViewController) {
      case (.Some("socialSegue"), let navigator as CollectionViewControllerSocial):
        if((UIImage(named: "wb")) != nil){
            println("wb")
        }else if((UIImage(named: "f3.png")) != nil){
            println("f3.png")
        }
        if(!wb.isEmpty){
            let imageName = "wb"
            let social = socialItem(url: wb, imgName: imageName)
            Socials.append(social)
        }
        if(!fb.isEmpty){
            let imageName = "fb"
            let social = socialItem(url: fb, imgName: imageName)
            Socials.append(social)
        }
        if(!tw.isEmpty){
            let imageName = "tw"
            let social = socialItem(url: tw, imgName: imageName)
            Socials.append(social)
        }
        
        if(!ig.isEmpty){
            let imageName = "ig"
            let social = socialItem(url: ig, imgName: imageName)
            Socials.append(social)
        }
        navigator.SocialItems = Socials
      default:
        super.prepareForSegue(segue, sender: sender)
        }

    }
    

    
}
