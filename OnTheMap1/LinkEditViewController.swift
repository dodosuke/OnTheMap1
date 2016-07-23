//
//  LinkEditViewController.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/21/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class LinkEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    var appDelegate: AppDelegate!
    var userLocation: StudentLocation?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        submitButton.enabled = false
        linkTextField.delegate = self
        
    }
    
    
    @IBAction func postInfo(sender: AnyObject) {
        
        if appDelegate.alreadyExist {
            InfoPutting()
        } else {
            InfoPosting()
        }
        
    }
    
    func InfoPosting() {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.URLs.Locations)!)
        request.HTTPMethod = "POST"
        request.addValue(Constants.OTMParameterValues.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.OTMParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let postingInfo = dataToJson()
        request.HTTPBody = postingInfo.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func InfoPutting() {
        
        let urlString = Constants.URLs.Locations + "/" + appDelegate.userObjectID!
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(Constants.OTMParameterValues.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.OTMParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postingInfo = dataToJson()
        request.HTTPBody = postingInfo.dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    @IBAction func backToMapSearch(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        submitButton.enabled = !(linkTextField.text!.isEmpty)
        appDelegate.userMediaURL = linkTextField.text!
        return true
    }
    
    func dataToJson() -> String {
        
        var postinginfo:String = ""
        let uniqueKey:String = "{\"uniqueKey\": \"" + appDelegate.userUniqueKey!
        let firstName:String = "\", \"firstName\": \"" + appDelegate.userFirstName!
        let lastName:String = "\", \"lastName\": \"" + appDelegate.userLastName!
        let mapString:String = "\",\"mapString\": \"" + appDelegate.userMapString!
        let mediaURL: String = "\", \"mediaURL\": \"" + appDelegate.userMediaURL!
        let lat: String = "\",\"latitude\": " + String(appDelegate.userLat!)
        let long: String = ", \"longitude\": " + String(appDelegate.userLong!) + "}"
        postinginfo = uniqueKey + firstName + lastName + mapString + mediaURL + lat + long
        
        return postinginfo
    }
    
}


