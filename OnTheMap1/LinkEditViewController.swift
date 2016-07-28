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
        
        let url = NSURL(string: Constants.URLs.Locations)!
        
        ParseClient.sharedInstance().getLocations(url, method: .POST) {(success, errorString) in
            if success {
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            } else {
                
            }
        }
    }
    
    
    func InfoPutting() {
        
        let url = NSURL(string: Constants.URLs.Locations + "/" + appDelegate.userObjectID!)
        
        ParseClient.sharedInstance().getLocations(url, method: .PUT) {(success, errorString) in
            if success {
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            } else {
                
            }
        }
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
    
}


