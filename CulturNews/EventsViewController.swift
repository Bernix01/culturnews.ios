//
//  EventsViewController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/23/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapleBacon
import Foundation

class EventsViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate {
    
    var events: [MrEvent] = []
    var offset: Int = 0
    var pages_tota: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Eventos"
        // Status bar white font
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        // Set custom indicator
        collectionView?.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
        
        // Set custom indicator margin
        collectionView?.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        collectionView?.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            let collectionView = scrollView as! UICollectionView
            
            self?.fetchData(self!.offset) {
                collectionView.finishInfiniteScroll()
               // self!.events.sort({$0.dateStart.isGreaterThanDate($1.dateStart)})
                //self.collectionView.reloadItemsAtIndexPaths(indexPaths)
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
        self.fetchData(self.offset) {
            println(self.events.count)
            if(self.events.count<9){
                self.fetchData(self.offset) {
                    println(self.events.count)
                if(self.events.count<9){
                    self.fetchData(self.offset,handler: nil)
                }
            }
            }
        }
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("clck")
        if let touch = touches.first as? UITouch{
            //transitionPoint = touch.locationInView(self.view)
        }
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Detail") as! DetailVController
        secondViewController.titlestr = events[indexPath.row].title
        secondViewController.cnt = events[indexPath.row].content
        secondViewController.imgurl = NSURL(string: events[indexPath.row].imgUrl)
        secondViewController.fb = events[indexPath.row].fb
        secondViewController.wb = events[indexPath.row].wb
        secondViewController.ig = events[indexPath.row].ig
        secondViewController.tw = events[indexPath.row].tw
        secondViewController.heightNav = self.navigationController?.navigationBar.frame.size.height
        
        self.showViewController(secondViewController, sender: secondViewController)
    }
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionWidth = CGRectGetWidth(collectionView.bounds);
        var itemWidth = collectionWidth / 3 - 2;
        return CGSizeMake(itemWidth, itemWidth*1.8);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
       override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.TitileTxtv.text = events[indexPath.row].title
        cell.TitileTxtv.sizeToFit()
        cell.DescrTxtv.text = events[indexPath.row].details
        cell.DescrTxtv.sizeToFit()
        cell.backgroundColor = getBGColore(indexPath.row)
        if let imageURL = NSURL(string: events[indexPath.row].imgUrl) {
            cell.HeaderImv.setImageWithURL(imageURL, cacheScaled: true)
        }
        return cell
    }
    func getBGColore(index: Int) -> UIColor{
        var pos = index%6
        switch(pos){
        case 0:
            return UIColor(rgba: "#4e4136")
        case 1:
            return UIColor(rgba: "#625343")
        case 2:
            return UIColor(rgba: "#373530")
        case 3:
            return UIColor(rgba: "#e1cb9a")
        case 4:
            return UIColor(rgba: "#5b5040")
        case 5:
            return UIColor(rgba: "#c5aa72")
        default:
            return UIColor(rgba: "#c5aa72")
        }
    }
    func setType (stype: String) -> Int {
        func toType (type: String) -> Int{
            switch type{
            case "TEATRO":
                return 0
            case "MUSICA CONTEMPORANEA":
                return 1
            case "MUSICA CLASICA":
                return 2
            case "DANZA":
                return 3
            case "PINTURA":
                return 4
            case "LITERATURA":
                return 5
            default:
                return 0;
            }
        }
        let ntype: Int = toType(stype)
        return ntype
    }
    private func fetchData(offset: Int,handler: (Void -> Void)?) {
        if(offset >= pages_tota*15){
            println("fail")
            handler?()
            return
        }
        Alamofire.request(.GET, "http://www.culturnews.com/endpoint/get/content/articles/", parameters: ["api_key": "IL5H9IGAWDCCKQQKWUDF","catid":"8","limit":"15","orderby":"created","maxsubs":"5","offset":offset])
            .responseJSON { (_, _, response, error) in
                //convert to SwiftJSON
                if(error != nil){
                    println(error)
                }else{
                let json = JSON(response!)
                if let status = json["status"].string{
                    if let pages = json["pages_total"].int{
                        println(pages)
                        self.pages_tota = pages
                    }
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                    
                    var indexPaths = [NSIndexPath]()
                    let firstIndex = self.events.count
                    var count = 0
                    for (index: String, subJson: JSON) in json["articles"] {
                        let indexPath = NSIndexPath(forItem: firstIndex + count, inSection: 0)
                        let submeta: JSON! = JSON(data:(subJson["metadata","xreference"].string!).dataUsingEncoding(NSUTF8StringEncoding)!)
                        let id: String = subJson["id"].string!
                        let s: NSDate = dateFormatter.dateFromString(self.tryGetString("s", json: submeta))!
                        let e: NSDate = dateFormatter.dateFromString(self.tryGetString("e", json: submeta))!
                        let type: Int = self.setType(self.tryGetString("category_title", json: subJson))
                        let event = MrEvent(title: self.tryGetString("title", json: subJson), detail: self.tryGetString("metadesc", json: subJson),dateStart: s , dateEnd: e,fb: self.tryGetString("fb", json: submeta), tw: self.tryGetString("tw", json: submeta),wb: self.tryGetString("w", json: submeta), ig: self.tryGetString("ig", json: submeta), content: String(htmlEncodedString: self.tryGetString("content", json: subJson)), type: type ,id: id.toInt()!,  imgurl: subJson["images"]["image_intro"].string!)
                        if (event.dateEnd.isGreaterThanDate(NSDate())) {
                            self.events.append(event)
                            println("\(id)")
                            indexPaths.append(indexPath)
                            count++
                        }
                    }
                    //self.events.sort({$0.dateStart.isGreaterThanDate($1.dateStart)})
            self.collectionView?.performBatchUpdates({ () -> Void in
                collectionView?.insertItemsAtIndexPaths(indexPaths)
                }, completion: { (finished) -> Void in
                    self.offset+=15
                    self.events.sort({$1.dateStart.isGreaterThanDate($0.dateStart)})
                    //self.collectionView?.reloadData()
                    self.collectionView?.reloadItemsAtIndexPaths((self.collectionView?.indexPathsForVisibleItems())!)
                    handler?()
                    
            });

                }else{
                    self.showAlertWithError(json["status"].error)
                    handler?()
                }
                }
        }
    }
    
    func tryGetString(name:String, json: JSON) -> String{
        var name = name
        if let str = json[name].string{
            return str
        }else{
            println(json[name].error)
            return ""
        }
    }
    private func showAlertWithError(error: NSError!) {
        let alert = UIAlertView(
            title: NSLocalizedString("Error fetching data", comment: ""),
            message: error.localizedDescription,
            delegate: self,
            cancelButtonTitle: NSLocalizedString("Dismiss", comment: ""),
            otherButtonTitles: NSLocalizedString("Retry", comment: "")
        )
        alert.show()
    }
    
}
