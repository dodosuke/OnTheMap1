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
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    
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
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
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
            self.presentViewController(alert, animated: true, completion: nil)
            
            let overwriteAction:UIAlertAction = UIAlertAction(title: "Overwrite", style: .Default, handler:{(action:UIAlertAction!) -> Void in
                self.presentViewController(InfoPoster, animated: true, completion: nil)
            })
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in})
            
            alert.addAction(overwriteAction)
            alert.addAction(cancelAction)
            
            self.navigationController?.pushViewController(alert, animated: true)
            
        } else {
            
            presentViewController(InfoPoster, animated: true, completion: nil)
            
        }
  
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        
        self.mapView.removeAnnotations(annotations)
        
        let url = NSURL(string: Constants.URLs.Locations + "?order=-updatedAt")!
        
        ParseClient.sharedInstance().getLocations(url, method: .GET) {(success, errorString) in
            if success {
                self.loadDataToMap()
            } else {
                self.displayError(errorString!)
            }
        }
    }
    
    private func displayError(error:String) {
        print(error)
        
        let alert:UIAlertController = UIAlertController(title:"Alert", message: error, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in})
        
        alert.addAction(cancelAction)
        
        self.navigationController?.pushViewController(alert, animated: true)
    }
    

    
}