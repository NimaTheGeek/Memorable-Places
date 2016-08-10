//
//  ViewController.swift
//  Memorable Places
//
//  Created by Nima Farahani on 8/9/16.
//  Copyright © 2016 Nima Farahani. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var manager: CLLocationManager!
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setting up user authorization for location use
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //check 
        if activePlaces == -1{
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        }else{
            
            let latitude = NSString(string: places[activePlaces]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlaces]["lon"]!).doubleValue
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let latDelta: CLLocationDegrees = 0.01
            let longDelta: CLLocationDegrees = 0.01
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            self.map.setRegion(region, animated: true)
            //add annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[activePlaces]["name"]
            //add annotation to the map
            self.map.addAnnotation(annotation)

        }
        

        
        //setting up long press for adding favourite places
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.0
        map.addGestureRecognizer(uilpgr)
        
    }
    
    // action when they long press
    func action(gestureRecognizer: UIGestureRecognizer){
        
        // check if that place has not been added to the map already
        if gestureRecognizer.state == UIGestureRecognizerState.Began{
            
            //get the points on map
            let touchPoint = gestureRecognizer.locationInView(self.map)
            //convert the points
            let newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                var title = ""
                
                if let firstPlacemark = placemarks?.first where error == nil {
                    
                    // print(firstPlacemark)
                    title = "\(firstPlacemark.subThoroughfare!) \(firstPlacemark.thoroughfare!), \(firstPlacemark.subAdministrativeArea!)"
                    
                    places.append(["name":title, "lat":"\(newCoordinate.latitude)" , "lon":"\(newCoordinate.longitude)"])
                    
                    
                    //add annotation
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    //add annotation to the map
                    self.map.addAnnotation(annotation)
                }
            }
        }
    }
    
    // setting up coordinates and moving object
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] 
        let latitude = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, long)
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

