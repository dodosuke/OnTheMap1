//
//  WebViewController.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/14/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    var targetURL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1468337398644000&usg=AFQjCNH1WVWhNmULqphHiOw9QX9FRcBuhA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadAddressURL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAddressURL() {
        let requestURL = NSURL(string: targetURL)
        let req = NSURLRequest(URL: requestURL!)
        webView.loadRequest(req)
    }
    
    @IBAction func cancelWebView(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
}