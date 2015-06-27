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