//
//  TableViewController.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/9/16.
//  Copyright © 2016 kishidak. All rights reserved.
//


import UIKit

class TableViewController: UITableViewController {
    
    var appDelegate: AppDelegate!
    
    var locations: [StudentLocation]!{
        get{return (UIApplication.sharedApplication().delegate as! AppDelegate).locations}
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView?.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = (location.firstName) + " " + (location.lastName)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: locations[indexPath.row].mediaURL)
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
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
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
        
        let url = NSURL(string: Constants.URLs.Locations + "?order=-updatedAt")!
        
        ParseClient.sharedInstance().getLocations(url, method: .GET) {(success, errorString) in
            if success {
                self.tableView?.reloadData()
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
