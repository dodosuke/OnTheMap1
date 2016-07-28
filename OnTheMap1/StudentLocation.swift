//
//  StudentLocation.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/12/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class StoringData {
    
    static var locations = [StudentLocation]?()
    
    var userObjectID:String? = nil
    var userUniqueKey: String? = nil
    var userFirstName: String? = nil
    var userLastName: String? = nil
    var userMediaURL: String? = nil
    var userMapString: String? = nil
    var userLat: Double? = nil
    var userLong: Double? = nil
    var alreadyExist: Bool = false
    
}

struct StudentLocation {

    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longtitude: Double
    var createdAt: String
    var updatedAt: String
    
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

