//
//  DetailVController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/27/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit

class DetailVController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var imgvw: UIImageView!
    var imgurl: NSURL?
    var cnt: String?
    var titlestr: String?
    var wb: String = ""
    var fb: String = ""
    var tw: String = ""
    var ig: String = ""
    
    
    @IBOutlet weak var titleTXT: UILabel!
    @IBOutlet weak var cntTXT: UITextView!
    @IBOutlet weak var socialvw: UIView!
    
    @IBAction func goBack(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cntTXT.text = cnt
        imgvw.setImageWithURL(imgurl!, cacheScaled: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if(!wb.isEmpty){
            let imageName = "icon-6.png"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            socialvw.addSubview(imageView)
        }
        if(!fb.isEmpty){
            let imageName2 = "icon-6.png"
            let image2 = UIImage(named: imageName2)
            let imageView2 = UIImageView(image: image2!)
            imageView2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            socialvw.addSubview(imageView2)
        }
        if(!tw.isEmpty){
            let imageName3 = "icon-6.png"
            let image3 = UIImage(named: imageName3)
            let imageView3 = UIImageView(image: image3!)
            imageView3.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            socialvw.addSubview(imageView3)
        }
        
        if(!ig.isEmpty){
            let imageName4 = "icon-6.png"
            let image4 = UIImage(named: imageName4)
            let imageView4 = UIImageView(image: image4!)
            imageView4.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            socialvw.addSubview(imageView4)
        }
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.hidden = false
        var logButton : UIBarButtonItem = UIBarButtonItem(title: "RigthButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        
        self.navigationController?.navigationItem.leftBarButtonItem = logButton
        self.title = "Your Title"
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
