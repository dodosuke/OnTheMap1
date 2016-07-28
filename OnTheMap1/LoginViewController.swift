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
        
        let url = NSURL(string:Constants.URLs.Session)!
        
        UdacityClient.sharedInstance().udacityLogIn(url, method: .POST, userId: usernameTextField.text!, userPW: passwordTextField.text!) {(success, errorString) in
            if success {
                self.getUserInfoFromUdacity()
            } else {
                self.displayError(errorString!)
            }
        }
    }
    
    func getUserInfoFromUdacity() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Getting Your Information from Udacity"
        }

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let url = NSURL(string: Constants.URLs.Users + appDelegate.userUniqueKey!)
        
        UdacityClient.sharedInstance().udacityLogIn(url, method: .GET, userId: usernameTextField.text!, userPW: passwordTextField.text!) {(success, errorString) in
            if success {
                self.getLocations()
            } else {
                self.displayError(errorString!)
            }
        }
    }
    
    func getLocations() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Getting student locations from Parse"
        }
        
        let url = NSURL(string: Constants.URLs.Locations + "?order=-updatedAt")!
        
        ParseClient.sharedInstance().getLocations(url, method: .GET) {(success, errorString) in
            if success {
                self.getUserInfoFromParse()
            } else {
                self.displayError(errorString!)
            }
        }
    }

    
    func getUserInfoFromParse() {
        
        dispatch_async(dispatch_get_main_queue()){
            self.debugTextLabel.text = "Getting Your Information from Parse"
        }
        
        let url = NSURL(string: Constants.URLs.LocationA + self.appDelegate.userUniqueKey! + Constants.URLs.LocationB)
        
        ParseClient.sharedInstance().getLocations(url, method: .GET) {(success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString!)
            }
        }
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
    
    private func displayError(error: String) {
        
        print(error)
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            self.debugTextLabel.text = "Login Failed (Login Step)."
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