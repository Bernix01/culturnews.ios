//
//  PlaceTypeController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/26/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//
//
//  EventsViewController.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/23/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit
import SwiftyJSON


    func getBGColor(index: Int) -> UIColor{
        //        3a2721  e48950  826335  3c2d2a  b75526  d59e5b
        var pos = index%6
        switch(pos){
        case 0:
            return UIColor(rgba: "#3a2721")
        case 1:
            return UIColor(rgba: "#e48950")
        case 2:
            return UIColor(rgba: "#826335")
        case 3:
            return UIColor(rgba: "#3c2d2a")
        case 4:
            return UIColor(rgba: "#b75526")
        case 5:
            return UIColor(rgba: "#d59e5b")
        default:
            return UIColor(rgba: "#d59e5b")
            
        }
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
    if let str = json[name].string{
        return (str as NSString).doubleValue
    }else{
        println(json[name].error)
        return 0
    }
}