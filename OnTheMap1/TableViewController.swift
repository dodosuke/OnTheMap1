//
//  TableViewController.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/9/16.
//  Copyright © 2016 kishidak. All rights reserved.
//


import UIKit

class TableViewController: UITableViewController {
    
    var locations: [StudentLocation]!{
        get{return (UIApplication.sharedApplication().delegate as! AppDelegate).locations}
        set{}
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
    
    @IBAction func PostInfo(sender: AnyObject) {
        
        let InfoPoster = storyboard!.instantiateViewControllerWithIdentifier("InfoPostViewController") as! InfoPostViewController
        presentViewController(InfoPoster, animated: true, completion: nil)
    
    
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: locations[indexPath.row].mediaURL)
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
        }
    
    }
    
}
