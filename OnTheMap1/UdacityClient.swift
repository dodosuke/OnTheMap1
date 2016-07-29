//
//  UdacityClient.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/27/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    func udacityLogIn(url: NSURL!, method: Constants.Method, userId: String, userPW: String, completionHandlerForUdacity: (success: Bool, errorString: String?) -> Void) {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: url)
        
        switch method {
        case .POST:
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let userInfo = self.userInfoToJson(userId, userPW: userPW)
            request.HTTPBody = userInfo.dataUsingEncoding(NSUTF8StringEncoding)
        case .DELETE:
            request.HTTPMethod = "DELETE"
            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        default:
            break
        }
        

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(error: String) {
                print(error)
                completionHandlerForUdacity(success: false, errorString: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
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
                sendError("No data was returned by the request!" )
                return
            }
            
            /* 5. Parse the data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            let parsedResult: AnyObject
            
            switch method {
            case .POST:
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                    if let account = parsedResult["account"] as? [String:AnyObject] {
                        StoringData.userUniqueKey = (account["key"] as? String)!
                    }
                } catch {
                    sendError("Could not parse the data as JSON")
                    return
                }
            case .DELETE:
                break
            default:
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                    if let user = parsedResult["user"] as? [String: AnyObject] {
                        StoringData.userFirstName = (user["first_name"] as? String)!
                        StoringData.userLastName = (user["last_name"] as? String)!
                        StoringData.userMapString? = (user["linkedin_url"] as? String)!
                    }
                } catch {
                    sendError("Could not parse the data as JSON")
                    return
                }
            }
            completionHandlerForUdacity(success: true, errorString: nil)
        }
        task.resume()
    }
    

    private func userInfoToJson(userId: String, userPW: String) -> String {
        
        let udacityId:String = "{\"udacity\": {\"username\": \"" + userId
        let udacityPW:String = "\", \"password\": \"" + userPW + "\"}}"
        let postingInfo = udacityId + udacityPW
        
        return postingInfo
        
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}