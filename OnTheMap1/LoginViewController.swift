//
//  LoginViewController.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 6/30/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            
            getSessionID()
        }
        
    }
    
    func getSessionID() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Getting sessionID from Udacity"
        }
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: NSURL(string:Constants.URLs.Session)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"kishidak@tcd.ie\", \"password\": \"xr5YAC2cUC\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (Login Step)."
                }
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
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            let parsedResult: AnyObject
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                if let account = parsedResult["account"] as? [String:AnyObject] {
                    self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.appDelegate.userUniqueKey = (account["key"] as? String)!
                }
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            
            /* 6. Use the data! */
            self.getUserInfoFromUdacity()
        }
        
        /* 7. Start the request */
        task.resume()
        
    }
    
    func getUserInfoFromUdacity() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Getting Your Information from Udacity"
        }

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.URLs.Users + appDelegate.userUniqueKey!)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (Login Step)."
                }
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
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            let parsedResult: AnyObject
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                if let user = parsedResult["user"] as? [String: AnyObject] {
                    self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.appDelegate.userFirstName = (user["first_name"] as? String)!
                    self.appDelegate.userLastName = (user["last_name"] as? String)!
                    self.appDelegate.userMapString? = (user["linkedin_url"] as? String)!
                }
                
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            self.getLocations()

        }
        task.resume()
    
    }
    
    func getLocations() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Getting student locations from Parse"
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.URLs.Locations)!)
        request.addValue(Constants.OTMParameterValues.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.OTMParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (Login Step)."
                }
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
                if let students = parsedResult["results"] as? [[String: AnyObject]] {
                    
                    self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.appDelegate.locations = StudentLocation.locationFromResults(students)
                    
                }
                
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            self.getUserInfoFromParse()
            
        }
        task.resume()
        
    }

    
    func getUserInfoFromParse() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Getting Your Information from Parse"
        }
        
        let url = NSURL(string: Constants.URLs.LocationA + self.appDelegate.userUniqueKey! + Constants.URLs.LocationB)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Constants.OTMParameterValues.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.OTMParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func displayError(error: String) {
                print(error)
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
                        
                        self.appDelegate.alreadyExist = false
                        
                    } else {
                        
                        self.appDelegate.userObjectID = results[0]["objectId"] as? String
                        self.appDelegate.alreadyExist = true
                        
                    }
                }
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            self.completeLogin()
            
        }
        task.resume()
        
    }
    
    private func completeLogin() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Login Completed"
        }
        
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OTMTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        let url = NSURL(string: Constants.URLs.SignUp)
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    
}

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}