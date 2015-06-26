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
    var dateStart: NSDate?
    var dateEnd: NSDate?
    let fb, tw, wb, ig: String
    let content: String
    let id: Int
    var type: Int!
    let stype: String
    let imgUrl: String
    
    init(title: String, detail: String, dateStart: String, dateEnd: String, fb:String,tw:String,wb:String,ig:String,content:String,typestr:String,id:Int,imgurl:String){
        self.title = title
        self.details = detail
        self.fb = fb
        self.tw = tw
        self.wb = wb
        self.ig = ig
        self.content = content
        self.stype = typestr
        self.id = id
        self.imgUrl = imgurl
        self.type = 0
        self.setType(dateStart,e: dateEnd)
        
    }
    
    func setType (s: String, e: String) {
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
        let ntype: Int = toType(self.stype)
        self.type = ntype
        let dateFormatter = NSDateFormatter()
        println(s+" "+e)
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.dateStart = dateFormatter.dateFromString(s)
        println(self.dateStart)
        self.dateEnd = dateFormatter.dateFromString(e)
        println(self.dateEnd)
    }
}