//
//  ParseClient.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/24/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    
    func getLocations(url: NSURL!, method: Constants.Method, completionHandlerForParse: (success: Bool, errorString: String?) -> Void) {

        let request = NSMutableURLRequest(URL: url!)
        
        switch method {
        case .POST: request.HTTPMethod = "POST"
        case .PUT: request.HTTPMethod = "PUT"
        default: break
        }
        
        request.addValue(Constants.OTMParameterValues.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.OTMParameterValues.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        switch method {
        case .GET: break
        default:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let postingInfo = userDataToJson()
            request.HTTPBody = postingInfo.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(error: String, debugLabelText: String? = nil) {
                print(error)
                completionHandlerForParse(success: false, errorString: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print(error)
                let errorString = error?.userInfo["NSLocalizedDescription"] as! String
                sendError(errorString)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                sendError("Your request returned a status code other than 2xx!: status code =" + String(statusCode!))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            
            let parsedResult: AnyObject

            switch method {
            case .GET:
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    if let results = parsedResult["results"] as? [[String: AnyObject]] {
                        if results.count == 0 {
                            
                            StoringData.alreadyExist = false
                            
                        } else if results.count == 1 {
                            
                            StoringData.userObjectID = results[0]["objectId"] as? String
                            StoringData.alreadyExist = true
                            
                        } else {

                        StoringData.locations = StudentLocation.locationFromResults(results)!
                        
                        }
                    }
                    
                } catch {
                    sendError("Could not parse the data as JSON")
                    return
                }
            default:
                break
            }
            
            completionHandlerForParse(success: true, errorString: nil)
            
        }
        task.resume()

    }
    
    
    private func userDataToJson() -> String {
        
        let uniqueKey:String = "{\"uniqueKey\": \"" + StoringData.userUniqueKey!
        let firstName:String = "\", \"firstName\": \"" + StoringData.userFirstName!
        let lastName:String = "\", \"lastName\": \"" + StoringData.userLastName!
        let mapString:String = "\",\"mapString\": \"" + StoringData.userMapString!
        let mediaURL: String = "\", \"mediaURL\": \"" + StoringData.userMediaURL!
        let lat: String = "\",\"latitude\": " + String(StoringData.userLat!)
        let long: String = ", \"longitude\": " + String(StoringData.userLong!) + "}"
        let postinginfo = uniqueKey + firstName + lastName + mapString + mediaURL + lat + long
        
        return postinginfo
    }
    
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}

