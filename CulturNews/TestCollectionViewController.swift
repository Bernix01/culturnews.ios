//
//  TestCollectionViewController.swift
//  NFTopMenuController
//
//  Created by Niklas Fahl on 12/17/14.
//  Copyright (c) 2014 Niklas Fahl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapleBacon

let reuseIdentifier = "MoodCollectionViewCell"

class TestCollectionViewController: UICollectionViewController, UIAlertViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    var Places: [Mrlace] = []
    var catid: Int = 0
    var offset: Int = 0
    var pages_tota: Int = 2
    var nh: CGFloat?
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

        self.collectionView!.registerNib(UINib(nibName: "MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Detail") as! DetailVController
        secondViewController.titlestr = Places[indexPath.row].name
        secondViewController.cnt = Places[indexPath.row].content
        secondViewController.imgurl = NSURL(string: Places[indexPath.row].himgurl)
        secondViewController.fb = Places[indexPath.row].fb
        secondViewController.wb = Places[indexPath.row].wb
        secondViewController.ig = Places[indexPath.row].ig
        secondViewController.tw = Places[indexPath.row].tw
        secondViewController.isPlac = true
        secondViewController.heightNav = nh
        println("\(secondViewController.heightNav)")
        self.presentViewController(secondViewController,animated: true, completion: nil)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionWidth = CGRectGetWidth(collectionView.bounds);
        var itemWidth = collectionWidth - 20;
        return CGSizeMake(itemWidth, 100);
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, catid: Int, nheight: CGFloat) {
        super.init(nibName: nibNameOrNil,bundle: nibBundleOrNil)
        self.catid = catid
        self.nh = nheight
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func shouldAutorotate() -> Bool {
        return false
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return Places.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : MoodCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoodCollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = getBGColore(indexPath.row)
        cell.name.text = Places[indexPath.row].name
        cell.descr.text = Places[indexPath.row].descr
        if let imageURL = NSURL(string: Places[indexPath.row].himgurl) {
            cell.himg.setImageWithURL(imageURL, cacheScaled: false)
        }
        return cell
    }
    
    private func fetchData(offset: Int,handler: (Void -> Void)?) {
        if(offset == pages_tota-1){
            handler?()
            return
        }
        Alamofire.request(.GET, "http://www.culturnews.com/endpoint/get/content/articles/", parameters: ["api_key": "IL5H9IGAWDCCKQQKWUDF","catid":self.catid,"limit":"15","orderby":"created","maxsubs":"5","offset":offset])
            .responseJSON { (_, _, response, error) in
                //convert to SwiftJSON
                if(error != nil){
                    println(error)
                }else{
                    let json = JSON(response!)
                    if let status = json["status"].string{
                        
                        self.pages_tota = json["pages_total"].int!
                        
                        var indexPaths = [NSIndexPath]()
                        let firstIndex = self.Places.count
                        var count = 0
                        for (index: String, subJson: JSON) in json["articles"] {
                            let indexPath = NSIndexPath(forItem: firstIndex + count, inSection: 0)
                            let id: String = subJson["id"].string!
                            let submeta: JSON! = JSON(data:(subJson["metadata","xreference"].string!).dataUsingEncoding(NSUTF8StringEncoding)!)
                            let place = Mrlace(
                                name: self.tryGetString("title", json: subJson),
                                conten: String(htmlEncodedString: self.tryGetString("content", json: subJson)),
                                descr: self.tryGetString("metadesc", json: subJson),
                                extra: self.tryGetString("wbrd", json: submeta),
                                fb: self.tryGetString("fb", json: submeta),
                                tw: self.tryGetString("tw", json: submeta),
                                wb: self.tryGetString("w", json: submeta),
                                ig: self.tryGetString("ig", json: submeta),
                                himgurl: self.tryGetString("image_intro", json: subJson["images"]),
                                x: self.tryDouble("x", json: submeta),
                                y: self.tryDouble("y", json: submeta))
                            self.Places.append(place)
                            indexPaths.append(indexPath)
                            count++
                        }
                        
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
    func tryDouble(name:String, json: JSON) -> Double{
        var name = name
        if let str = json[name].double{
            return str
        }else{
            println(json[name].error)
            return 0
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
