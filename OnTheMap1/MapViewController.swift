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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let locations = self.appDelegate.locations
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for location in locations! {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longtitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
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
    
    @IBAction func PostInfo(sender: AnyObject) {
        
        let url = NSURL(string: Constants.URLs.LocationA + self.appDelegate.userUniqueKey! + Constants.URLs.LocationB)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Constants.OTMParameterValues.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.OTMParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func displayError(error: String) {
                print(error)
                
                let alert:UIAlertController = UIAlertController(title:"Alert", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                let okAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction!) -> Void in })
                alert.addAction(okAction)
                self.navigationController?.pushViewController(alert, animated: true)
                
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            
            let parsedResult: AnyObject
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let results = parsedResult["results"] as? [[String:AnyObject]] {
                    if results.count == 0 {
                        
                        self.presentInfoPoster()
                        
                    } else {
                        
                        self.appDelegate.userObjectID = results[0]["objectId"] as? String
                        self.appDelegate.alreadyExist = true
                        self.overwriteInfo()
                        
                    }
                }
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            
        }
        task.resume()
        
    }
    
    func overwriteInfo() {
        
        let alert:UIAlertController = UIAlertController(title:"Alert", message: "You have already posted a student location. Would you like to overwrite?", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        let overwriteAction:UIAlertAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler:{(action:UIAlertAction!) -> Void in self.presentInfoPoster()})
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in})

        alert.addAction(overwriteAction)
        alert.addAction(cancelAction)
       
        self.navigationController?.pushViewController(alert, animated: true)

        
    }
    
    func presentInfoPoster() {
        
        let InfoPoster = storyboard!.instantiateViewControllerWithIdentifier("InfoPostViewController") as! InfoPostViewController
        presentViewController(InfoPoster, animated: true, completion: nil)
        
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        
//        let request = NSMutableURLRequest(URL: NSURL(string: Constants.URLs.Locations)!)
//        request.addValue(Constants.OTMParameterValues.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue(Constants.OTMParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            
//            // if an error occurs, print it and re-enable the UI
//            func displayError(error: String, debugLabelText: String? = nil) {
//                print(error)
//            }
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                displayError("There was an error with your request: \(error)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                displayError("Your request returned a status code other than 2xx!")
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                displayError("No data was returned by the request!")
//                return
//            }
//            
//            /* 5. Parse the data */
//            
//            let parsedResult: AnyObject
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//                if let students = parsedResult["results"] as? [[String: AnyObject]] {
//                    
//                    self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                    self.appDelegate.locations = StudentLocation.locationFromResults(students)
//                    
//                }
//                
//            } catch {
//                displayError("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            
//        }
//        task.resume()
        
    }
    
    
    
}