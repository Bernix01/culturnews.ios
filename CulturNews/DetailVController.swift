//
//  DetailVController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/27/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import AVKit

class DetailVController: UIViewController, UINavigationBarDelegate {
    

    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var imgvw: UIImageView!
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    var imgurl: NSURL?
    var cnt: String?
    var titlestr: String?
    var wb: String = ""
    var fb: String = ""
    var tw: String = ""
    var ig: String = ""
    var xp: Double = 0
    var yp: Double = 0
    var isPlac: Bool = false
    var isNew: Bool = false
    var heightNav: CGFloat?
    var isplayingAudio = false
    var Socials: [socialItem] = []
    var wbrd: String = ""
    var AudioPlayerasd: AVPlayer! = nil
    @IBOutlet weak var cntTXT: UITextView!
    @IBOutlet weak var txtcbtwidth: NSLayoutConstraint!
    @IBOutlet weak var imghWidth: NSLayoutConstraint!
    @IBOutlet weak var cntSocialWidth: NSLayoutConstraint!
    @IBOutlet weak var playPause: UIButton!
    @IBAction func playPauseRadio(sender: AnyObject) {
        if isplayingAudio {
            AudioPlayerasd.pause()
            isplayingAudio = false
            playPause.setImage(UIImage(named: "nplay"), forState: .Normal)
        }else{
            AudioPlayerasd.play()
            isplayingAudio = true
            playPause.setImage(UIImage(named: "npause"), forState: .Normal)
        }
    }
    
    @IBOutlet weak var mapcnt: UIView!
    @IBOutlet weak var mapWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("\(wbrd)")
        if(isPlac){
            println("yay")
            if !wbrd.isEmpty{
                println("yay2")
                println(wbrd)
                var err: NSError?
                let url = wbrd
                AudioPlayerasd = AVPlayer(URL: NSURL(string: url))
            }else{
                playPause.hidden = true
            }
        }else{
            playPause.hidden = true
        }
        if isNew{
            mapcnt.hidden = true
        }
        println("content \(cnt)")
        if(cnt == ""){
            cntTXT.backgroundColor = UIColor(rgba: "#fff")
            println("yay3")
            cntTXT.hidden = true
        }
        if (cnt?.isEmpty == nil){
            println("yay3")
            cntTXT.hidden = true
        }
        println("x: \(xp) y: \(yp)")
        mapWidth.constant = self.view.frame.width
        cntSocialWidth.constant = self.view.frame.width
        imghWidth.constant = self.view.frame.width
        scroll.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        txtcbtwidth.constant = self.view.frame.width
        scroll.backgroundColor = UIColor(rgba: "#000")
        scroll.scrollEnabled = true
        scroll.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height)

        cntTXT.text = cnt
        imgvw.frame = CGRectMake(0, 0, self.view.frame.width/2, self.view.frame.width/2)
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
        
      case (.Some("mapcontainer"), let navigator as MapVC):
        navigator.xp = xp
        navigator.yp = yp
        navigator.titlestr = titlestr
    default:
        super.prepareForSegue(segue, sender: sender)
        }

    }
    

    
}
