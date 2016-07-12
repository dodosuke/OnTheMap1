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
        
        // Set the name and image
        cell.textLabel?.text = (location.firstName) + (location.lastName)
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    

    
    
    //  call the meme viewer and editor
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
//        let detailController = object as! MemeDetailViewController
//        detailController.index = indexPath.row
//        navigationController!.pushViewController(detailController, animated: true)
//    }
    
    
}
