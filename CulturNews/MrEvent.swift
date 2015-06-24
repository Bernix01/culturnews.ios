//
//  MrEvent.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/23/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import Foundation
class MrEvent {
    let title: String
    let details: String
    let dateStart: NSDate
    let dateEnd: NSDate
    let fb, tw, wb, ig: String
    let content: String
    let type,id: Int
    let imgUrl: String
    
    init(title: String, detail: String, dateStart: String, dateEnd: String, fb:String,tw:String,wb:String,ig:String,content:String,type:Int,id:Int,imgurl:String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        self.title = title
        self.details = detail
        self.fb = fb
        self.tw = tw
        self.wb = wb
        self.ig = ig
        self.content = content
        self.type = type
        self.id = id
        self.imgUrl = imgurl
        self.dateStart = dateFormatter.dateFromString(dateStart)!
        self.dateEnd = dateFormatter.dateFromString(dateEnd)!
        
    }
    
}