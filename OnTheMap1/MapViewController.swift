//
//  MapViewController.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/10/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    var appDelegate: AppDelegate!
    var loginViewController: LoginViewController!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataToMap()
        
    }
    
    func loadDataToMap() {
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let locations = self.appDelegate.locations
        
        annotations = []
        
        for location in locations! {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longtitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        let url = NSURL(string: Constants.URLs.Session)!
        
        UdacityClient.sharedInstance().udacityLogIn(url, method: .DELETE, userId: "", userPW: "") {(success, errorString) in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayError(errorString!)
            }
        }
    }
    
    
    @IBAction func PostInfo(sender: AnyObject) {
        
        let InfoPoster = storyboard!.instantiateViewControllerWithIdentifier("InfoPostViewController") as! InfoPostViewController
        
        if self.appDelegate.alreadyExist {
            
            let alert:UIAlertController = UIAlertController(title:"Alert", message: "You have already posted a student location. Would you like to overwrite?", preferredStyle: .Alert)
            
            let overwriteAction:UIAlertAction = UIAlertAction(title: "Overwrite", style: .Default, handler:{(action:UIAlertAction!) -> Void in
                self.presentViewController(InfoPoster, animated: true, completion: nil)
            })
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in})
            
            alert.addAction(overwriteAction)
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            presentViewController(InfoPoster, animated: true, completion: nil)
            
        }
  
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        
        self.mapView.removeAnnotations(annotations)
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
        
        let url = NSURL(string: Constants.URLs.Locations + "?order=-updatedAt")!
        
        ParseClient.sharedInstance().getLocations(url, method: .GET) {(success, errorString) in
            if success {
                self.loadDataToMap()
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()
            } else {
                self.displayError(errorString!)
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func displayError(error:String) {
        print(error)
        
        let alert:UIAlertController = UIAlertController(title:"Alert", message: error, preferredStyle: .Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in})
        
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    

    
}