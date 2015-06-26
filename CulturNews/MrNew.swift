//
//  MrNew.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/26/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import Foundation
class MrNew {
    let title: String
    var date: NSDate?
    var hdate: String?
    let content: String
    let imgurl: String
    var type: Int?
    let id: Int

    init(title: String,date: String, content: String, imgurl: String, type: String, id: Int){
        self.title = title
        self.content = content
        self.imgurl=imgurl
        self.id=id
        setIt(date, type: type)
    }
    func setIt(date: String, type: String){
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
        self.type = toType(type)
        let dateFormatter = NSDateFormatter()
        println(date)
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = dateFormatter.dateFromString(date)
        self.hdate = NSDateFormatter.localizedStringFromDate(self.date!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    }

}
