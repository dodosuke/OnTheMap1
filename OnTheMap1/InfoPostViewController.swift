//
//  InfoPostViewController.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/18/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import MapKit

class InfoPostViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var destSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextStep: UIBarButtonItem!
    
    var locationManager: CLLocationManager!
    var destLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        mapView.delegate = self
        destSearchBar.delegate = self
        destSearchBar.text = ""
        nextStep.enabled = false
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        destSearchBar.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destSearchBar.text!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (error == nil) {
                if let placemark = placemarks![0] as? CLPlacemark {
                    self.destLocation = CLLocationCoordinate2DMake(placemark.location!.coordinate.latitude, placemark.location!.coordinate.longitude)
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    self.locationManager.startUpdatingLocation()
                    self.showOnMap()
                    self.nextStep.enabled = true
                }
            } else {
                self.errorPopUp()
            }
        })
    }
    
    func showOnMap() {
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.10, 0.10);
        let center:CLLocationCoordinate2D = destLocation
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        mapView.setRegion(mapView.regionThatFits(region), animated:true)
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func errorPopUp() {
        
        let alert:UIAlertController = UIAlertController(title:"Alert", message: "Cannot find the place", preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alert, animated: true, completion: nil)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction!) -> Void in })
        alert.addAction(cancelAction)
        self.navigationController?.pushViewController(alert, animated: true)

    }

    
}