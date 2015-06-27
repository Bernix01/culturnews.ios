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
    let id: Int
    var type: Int
    let imgUrl: String
    
    init(title: String, detail: String, dateStart: NSDate, dateEnd: NSDate, fb:String,tw:String,wb:String,ig:String,content:String,type:Int,id:Int,imgurl:String){
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
        self.type = 0
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }
    
}