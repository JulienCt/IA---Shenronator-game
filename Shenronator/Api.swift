//
//  Api.swift
//  Shenronator
//
//  Created by Julien Catteau on 15/04/16.
//  Copyright © 2016 Julien Catteau. All rights reserved.
//

import Foundation
public class Api
{
    //Méthode qui permet de se connecter à l'API Node
    //doSomethingWithJson => Ici on passe une fonction qui traitera le json
    public func getRequestOnAPI(apiUrl: String, doSomethingWithJson: (NSDictionary) -> ())
    {
        let url = apiUrl;
        let requestURL: NSURL = NSURL(string: url)!;
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL);
        let session = NSURLSession.sharedSession();
        let task = session.dataTaskWithRequest(urlRequest)
        {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments);
                    if let dict = json as? NSDictionary {
                        doSomethingWithJson(dict);
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
            }
        };
        task.resume();
    }
    
    //Permet de réaliser un post sur les webservices
    public func postRequestOnApi(json : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        let session = NSURLSession.sharedSession();
        request.HTTPMethod = "POST";
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted);
        } catch {
            print(error);
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                                          print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
        }
        
        task.resume()
    }
}