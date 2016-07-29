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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        submitButton.enabled = false
        linkTextField.delegate = self
        
    }
    
    
    @IBAction func postInfo(sender: AnyObject) {
        
        if StoringData.alreadyExist {
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
                self.displayError(errorString!)
            }
        }
    }
    
    
    func InfoPutting() {
        
        let url = NSURL(string: Constants.URLs.Locations + "/" + StoringData.userObjectID!)
        
        ParseClient.sharedInstance().getLocations(url, method: .PUT) {(success, errorString) in
            if success {
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayError(errorString!)
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
    
    
    @IBAction func backToMapSearch(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        submitButton.enabled = !(linkTextField.text!.isEmpty)
        StoringData.userMediaURL = linkTextField.text!
        return true
    }
    
}


