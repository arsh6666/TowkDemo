//
//  ApiResource.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import Foundation
import Network

class ApiResource {
    
    
    static func getHeader() -> HTTPHeaders {
    
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Encoding":"gzip,deflate",
            "Content-Type" :"application/json"

        ]
        return headers;
    }
    
    
    static func getParameterData<T: Codable>(model:T)->Data?{
          

        guard let data = try? JSONEncoder().encode(model) else {
                   return nil
        }
          return data
    }

    //MARK:- Resources
    
    static func getUserListResource(since:Int) -> Resource<[User]>?{
        let urlString : String = "https://api.github.com/users?since=\(since)"
    
        guard let url = URL(string: urlString) else{
            return nil
        }
      
        return  Resource<[User]>(url: url , httpMethod: .get,httpHeader: ApiResource.getHeader())
        
    }
    
    static func getUserDetailResource(username:String) -> Resource<User>?{
        let urlString : String = "https://api.github.com/users/\(username)"
    
        guard let url = URL(string: urlString) else{
            return nil
        }
      
        return  Resource<User>(url: url , httpMethod: .get,httpHeader: ApiResource.getHeader())
        
    }
}

