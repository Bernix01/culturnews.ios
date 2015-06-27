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
    var pages_tota: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "sdfs"
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
    override func viewWillAppear(animated: Bool){
        navigationItem.title = "eventos"
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(100, 100);
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
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "Header",
                    forIndexPath: indexPath)
                    as! HeaderReusableViewq
                headerView.label.text = "Eventos"
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
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
        if(offset == pages_tota-1){
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
                    self.pages_tota = json["pages_total"].int!
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
                            indexPaths.append(indexPath)
                            count++
                        }
                    }
                    self.events.sort({$0.dateStart.isGreaterThanDate($1.dateStart)})
            self.collectionView?.performBatchUpdates({ () -> Void in
                collectionView?.insertItemsAtIndexPaths(indexPaths)
                }, completion: { (finished) -> Void in
                    self.offset++
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
