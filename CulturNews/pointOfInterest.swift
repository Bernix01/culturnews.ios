//
//  pointOfInterest.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/30/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//
import MapKit

class pointOfInterest: NSObject, MKAnnotation {
    let title: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
}