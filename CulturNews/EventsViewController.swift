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
    
    private let apiURL = "https://api.flickr.com/services/feeds/photos_public.gne?nojsoncallback=1&format=json"
    var events: [MrEvent] = []
    var width : CGFloat?
    var offset: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set custom indicator
        collectionView?.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
        
        // Set custom indicator margin
        collectionView?.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        collectionView?.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            let collectionView = scrollView as! UICollectionView
            
            self?.fetchData(self!.offset) {
                collectionView.finishInfiniteScroll()
            }
        }
        
        fetchData(self.offset,handler: nil)

    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionWidth = CGRectGetWidth(collectionView.bounds);
        var itemWidth = collectionWidth / 3 - 1;
        
        width = itemWidth
        
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
        if let imageURL = NSURL(string: events[indexPath.row].imgUrl) {
            cell.HeaderImv.setImageWithURL(imageURL)
        }
        return cell
    }
    private func fetchData(offset: Int,handler: (Void -> Void)?) {
        Alamofire.request(.GET, "http://www.culturnews.com/endpoint/get/content/articles/", parameters: ["api_key": "IL5H9IGAWDCCKQQKWUDF","catid":"8","limit":"30","orderby":"created","maxsubs":"5","offset":offset])
            .responseJSON { (_, _, response, _) in
                //convert to SwiftJSON
                let json = JSON(response!)
                if let status = json["status"].string{
                    
                    
                    var indexPaths = [NSIndexPath]()
                    let firstIndex = self.events.count
                    var count = 0
                    for (index: String, subJson: JSON) in json["articles"] {
                        let indexPath = NSIndexPath(forItem: firstIndex + count, inSection: 0)
                        let submeta: JSON! = JSON(data:(subJson["metadata","xreference"].string!).dataUsingEncoding(NSUTF8StringEncoding)!)
                        let id: String = subJson["id"].string!
                        let event = MrEvent(title: self.tryGetString("title", json: subJson), detail: self.tryGetString("metadesc", json: subJson),dateStart: self.tryGetString("s", json: submeta) , dateEnd: self.tryGetString("e", json: submeta),fb: self.tryGetString("fb", json: submeta), tw: self.tryGetString("tw", json: submeta),wb: self.tryGetString("w", json: submeta), ig: self.tryGetString("ig", json: submeta), content: self.tryGetString("content", json: subJson), typestr: self.tryGetString("category_title", json: subJson),id: id.toInt()!,  imgurl: subJson["images"]["image_intro"].string!)
                        if (event.dateEnd!.isGreaterThanDate(NSDate())) {
                            self.events.append(event)
                            indexPaths.append(indexPath)
                            count++
                        }
                    }
                    self.events.sort({$0.dateStart!.isGreaterThanDate($1.dateStart!)})
            self.collectionView?.performBatchUpdates({ () -> Void in
                collectionView?.insertItemsAtIndexPaths(indexPaths)
                }, completion: { (finished) -> Void in
                    self.offset++
            });

                }else{
                    self.showAlertWithError(json["status"].error)
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

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    
    
    func addDays(daysToAdd : Int) -> NSDate
    {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate
    {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

