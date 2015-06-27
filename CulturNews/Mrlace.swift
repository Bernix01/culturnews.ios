//
//  Mrlace.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/26/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import Foundation
class Mrlace {
    let name: String
    var timeto: String?
    var rtimeto: Int?
    let x, y: Double
    let himgurl: String
    let content: String
    let descr: String
    let extra: String
    let fb, tw, wb, ig: String
    var distanceto: Float?
    
    init(name: String, conten: String, descr: String, extra: String, fb: String, tw: String, wb: String, ig: String, himgurl: String, x: Double, y: Double){
        self.name = name
        self.content = conten
        self.descr = descr
        self.extra = extra
        self.fb = fb
        self.tw = tw
        self.wb = wb
        self.ig = ig
        self.himgurl = himgurl
        self.x = x
        self.y = y
    }
}