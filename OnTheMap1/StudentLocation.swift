//
//  StudentLocation.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/12/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation

struct StudentLocation {

    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longtitude: Double
    let createdAt: String
    let updatedAt: String
    
    init(dictionary:[String:AnyObject]){
        objectId = dictionary[Constants.OTMResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[Constants.OTMResponseKeys.UniqueKey] as! String
        firstName = dictionary[Constants.OTMResponseKeys.FirstName] as! String
        lastName = dictionary[Constants.OTMResponseKeys.LastName] as! String
        mapString = dictionary[Constants.OTMResponseKeys.MapString] as! String
        mediaURL = dictionary[Constants.OTMResponseKeys.MediaURL] as! String
        latitude = dictionary[Constants.OTMResponseKeys.Latitude] as! Double
        longtitude = dictionary[Constants.OTMResponseKeys.Longtitude] as! Double
        createdAt = dictionary[Constants.OTMResponseKeys.CreatedDate] as! String
        updatedAt = dictionary[Constants.OTMResponseKeys.UpdatedDate] as! String
    }
    
    static func locationFromResults(results: [[String:AnyObject]]) -> [StudentLocation]? {
        
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
    
        return locations
    }
    
}

