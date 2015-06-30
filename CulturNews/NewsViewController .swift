//
//  newsViewController.swift
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

class NewsViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate {
    
    private let apiURL = "https://api.flickr.com/services/feeds/photos_public.gne?nojsoncallback=1&format=json"
    var news: [MrNew] = []
    var width : CGFloat?
    var offset: Int = 0
    var isLoadingData = false
    var pages_tota: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Noticias"
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
        var itemWidth = collectionWidth - 2;
        
        width = itemWidth
        
        return CGSizeMake(itemWidth, itemWidth*0.5);
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
        return news.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: NewCell = collectionView.dequeueReusableCellWithReuseIdentifier("nCell", forIndexPath: indexPath) as! NewCell
        cell.nTitle.text = news[indexPath.row].title
        cell.nDescr.text = news[indexPath.row].content
        cell.ndate.text = news[indexPath.row].hdate
        cell.backgroundColor = getBGColor(indexPath.row)
        if let imageURL = NSURL(string: news[indexPath.row].imgurl) {
            cell.nImage.setImageWithURL(imageURL, cacheScaled: true)
        }
        return cell
    }
    private func fetchData(offset: Int,handler: (Void -> Void)?) {
        
        if isLoadingData{
            handler?()
            return
        }
        if(offset >= pages_tota*15){
            println("fail")
            self.isLoadingData = false
            handler?()
            return
        }
        self.isLoadingData = true
        Alamofire.request(.GET, "http://www.culturnews.com/endpoint/get/content/articles/", parameters: ["api_key": "IL5H9IGAWDCCKQQKWUDF","catid":"9","limit":"30","orderby":"created","orderdir": "desc","maxsubs":"5","offset":offset])
            .responseJSON { (_, _, response, error) in
                //convert to SwiftJSON
                if(error != nil){
                    println(error)
                }else{
                let json = JSON(response!)
                if let status = json["status"].string{
                    
                    self.pages_tota = json["pages_total"].int!
                    
                    var indexPaths = [NSIndexPath]()
                    let firstIndex = self.news.count
                    var count = 0
                    for (index: String, subJson: JSON) in json["articles"] {
                        let indexPath = NSIndexPath(forItem: firstIndex + count, inSection: 0)
                        let id: String = subJson["id"].string!
                        let event = MrNew(title: self.tryGetString("title", json: subJson), date: self.tryGetString("published_date", json: subJson), content: String(htmlEncodedString: self.tryGetString("content", json: subJson)),imgurl: subJson["images"]["image_intro"].string!,type: self.tryGetString("category_title", json: subJson),id: id.toInt()!)
                        
                        self.news.append(event)
                            indexPaths.append(indexPath)
                            count++
                    }
                    
                    self.collectionView?.performBatchUpdates({ () -> Void in
                        collectionView?.insertItemsAtIndexPaths(indexPaths)
                        }, completion: { (finished) -> Void in
                            self.offset+=15
                            self.isLoadingData = false
                            handler?()
                            
                    });
                    
                }else{
                    self.showAlertWithError(json["status"].error)
                    self.isLoadingData = false
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
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Detail") as! DetailVController
        secondViewController.titlestr = news[indexPath.row].title
        secondViewController.cnt = news[indexPath.row].content
        secondViewController.imgurl = NSURL(string: news[indexPath.row].imgurl)
        secondViewController.isNew = true
        self.showViewController(secondViewController, sender: secondViewController)
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
extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)!
        self.init(attributedString.string)
    }
}


