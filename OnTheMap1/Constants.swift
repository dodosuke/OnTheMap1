//
//  Constants.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/1/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation

struct Constants {
    
    struct URLs {
        static let Session = "https://www.udacity.com/api/session"
        static let Locations = "https://api.parse.com/1/classes/StudentLocation"
        static let Users = "https://www.udacity.com/api/users/"
        static let SignUp = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1468337398644000&usg=AFQjCNH1WVWhNmULqphHiOw9QX9FRcBuhA"
        static let LocationA = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22"
        static let LocationB = "%22%7D"
    }
    
    struct OTMParameterKeys {
        static let AppID = "app_id"
        static let ApiKey = "api_key"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    struct OTMParameterValues {
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct OTMResponseKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longtitude = "longitude"
        static let CreatedDate = "createdAt"
        static let UpdatedDate = "updatedAt"
    }
    
}