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
import Foundation

class EventsViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate {
    
    private let apiURL = "https://api.flickr.com/services/feeds/photos_public.gne?nojsoncallback=1&format=json"
    var tableData: [String] = ["ssdf","assdf","sdfsfs"]
   /* override func viewDidAppear(animated: Bool) {
        Alamofire.request(.GET, "http://www.culturnews.com/endpoint/", parameters: ["api_key": "bar","catid":"limit","limit":"30","orderby":"created","maxsubs":"5"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set custom indicator
        collectionView?.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
        
        // Set custom indicator margin
        collectionView?.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        collectionView?.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            let collectionView = scrollView as! UICollectionView
            
            self?.fetchData() {
                collectionView.finishInfiniteScroll()
            }
        }
        
        fetchData(nil)

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionWidth = CGRectGetWidth(collectionView.bounds);
        var itemWidth = collectionWidth / 3 - 1;
        
        if(UI_USER_INTERFACE_IDIOM() == .Pad) {
            itemWidth = collectionWidth / 4 - 1;
        }
        
        return CGSizeMake(itemWidth, itemWidth);
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
        return tableData.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.DescrTxt.text = tableData[indexPath.row]
        return cell
    }
    private func fetchData(handler: (Void -> Void)?) {
        Alamofire.request(.GET, "http://www.culturnews.com/endpoint/get/content/articles/", parameters: ["api_key": "IL5H9IGAWDCCKQQKWUDF","catid":"limit","limit":"30","orderby":"created","maxsubs":"5"])
            .responseJSON { (_, _, response, _) in
                //convert to SwiftJSON
                let json = JSON(response!)
                println(json)
        }
        /* var indexPaths = [NSIndexPath]()
        let firstIndex = tableData.count
        let responseDict = NSJSONSerialization.JSONObjectWithData(fixedData!, options: NSJSONReadingOptions.allZeros, error: &jsonError) as? Dictionary<String, AnyObject>
        
        if jsonError != nil {
            showAlertWithError(jsonError)
            completion?()sdasd
            return
        }

        if let items = responseDict?["items"] as? NSArray {
            if let urls = items.valueForKeyPath("media.m") as? [String] {
                for (i, url) in enumerate(urls) {
                    let indexPath = NSIndexPath(forItem: firstIndex + i, inSection: 0)
                    
                    photos.append(NSURL(string: url)!)
                    indexPaths.append(indexPath)
                }
            }
        }

        collectionView?.performBatchUpdates({ () -> Void in
            collectionView?.insertItemsAtIndexPaths(indexPaths)
            }, completion: { (finished) -> Void in
                completion?()
        });*/
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
