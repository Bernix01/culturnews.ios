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
    var isLoadingData = false
    var parent: PlacesVcontroller?
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
        secondViewController.xp = Places[indexPath.row].x
        secondViewController.yp = Places[indexPath.row].y
        secondViewController.wbrd = Places[indexPath.row].extra
        println("\(secondViewController.heightNav)")
       parent!.goTo(secondViewController)//(secondViewController,animated: true, completion: nil)
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
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, catid: Int, nheight: CGFloat, parent: PlacesVcontroller) {
        super.init(nibName: nibNameOrNil,bundle: nibBundleOrNil)
        self.catid = catid
        self.parent = parent
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
        if isLoadingData{
            handler?()
            return
        }
        if(offset >= pages_tota*15){
            println("fail")
            handler?()
            self.isLoadingData = false
            return
        }
        self.isLoadingData = true
        Alamofire.request(.GET, "http://www.culturnews.com/endpoint/get/content/articles/", parameters: ["api_key": "IL5H9IGAWDCCKQQKWUDF","catid":self.catid,"limit":"15","orderby":"created","orderdir":"desc","maxsubs":"5","offset":offset])
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
                                name: tryGetString("title",  subJson),
                                conten: String(htmlEncodedString: tryGetString("content",  subJson)),
                                descr: tryGetString("metadesc",  subJson),
                                extra: tryGetString("wbrdi",  submeta),
                                fb: tryGetString("fb",  submeta),
                                tw: tryGetString("tw",  submeta),
                                wb: tryGetString("w",  submeta),
                                ig: tryGetString("ig",  submeta),
                                himgurl: tryGetString("image_intro",  subJson["images"]),
                                x: tryDouble("x",  submeta),
                                y: tryDouble("y",  submeta))
                            self.Places.append(place)
                            indexPaths.append(indexPath)
                            println(place.extra)
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
