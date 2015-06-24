//
//  EventsViewController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/23/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit
import Alamofire

class EventsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.DescrTxt.text = tableData[indexPath.row]
        return cell
    }
}
