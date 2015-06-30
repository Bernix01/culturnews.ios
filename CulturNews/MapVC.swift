//
//  MapVC.swift
//  CulturNews
//
//  Created by GUILLERMO BERNAL on 6/30/15.
//  Copyright (c) 2015 CulturNews. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    // set initial location in Honolulu
    var xp,yp: Double?
    var titlestr: String?
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("x: \(xp) y: \(yp)")
        var initialLocation = CLLocation(latitude: xp!, longitude: yp!)
        centerMapOnLocation(initialLocation)
        let artwork = pointOfInterest(title: titlestr!,
            locationName: "",
            discipline: "",
            coordinate: CLLocationCoordinate2D(latitude: xp!, longitude: yp!))
        
        mapView.addAnnotation(artwork)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
