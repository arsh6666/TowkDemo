//
//  ApiClient.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import Foundation
import UIKit
import SystemConfiguration

public typealias HTTPHeaders = [String: String]

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod
    var body: Data? = nil
    var httpHeader :  HTTPHeaders
}

extension Resource {
    init(url: URL,httpMethod :HttpMethod , httpHeader :HTTPHeaders) {
        self.url = url
        self.httpMethod = httpMethod
        self.httpHeader = httpHeader
    }
}

class ApiClient {
    
    
    
    
   func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {

    if !ApplicationSession.isOnline() {
        ApplicationSession.ShowAlertMethod(message: "Internet Not Found")
        return
    }
        showProgress()
    print(resource.url.absoluteString);
    
    
       var request = URLRequest(url: resource.url)
       request.httpMethod = resource.httpMethod.rawValue
       request.httpBody = resource.body
       request.allHTTPHeaderFields = resource.httpHeader
       
       let sessionConfig = URLSessionConfiguration.default
       sessionConfig.timeoutIntervalForRequest = 30.0
       sessionConfig.timeoutIntervalForResource = 60.0
       let session = URLSession(configuration: sessionConfig)
       session.dataTask(with: request) { data, response, error in
           
           let httpResponse = response as? HTTPURLResponse
           
           print(httpResponse?.statusCode as Any)
        
           DispatchQueue.main.async {
            
           if httpResponse?.statusCode != 200  {
            self.hideProgress()
            ApplicationSession.ShowAlertMethod(message: "Something went wrong")
           }
           else{
            
            
          //  print(json)
               guard let data = data, error == nil else {
                   
                   self.log(request: request, responce: error?.localizedDescription)
                   completion(.failure(.domainError))
                   return
               }
               
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)

          //  print(json)
              // let str = String(decoding: data, as: UTF8.self)
               
               let result = try? JSONDecoder().decode(T.self, from: data)
               
                self.log(request: request, responce: data)
                self.hideProgress()
                if let dataModel = result {
                  completion(.success(dataModel))
                  return
               }
               else
               {
                    completion(.failure(.decodingError))
                ApplicationSession.ShowAlertMethod(message: "error_date_not_parsed_properly")
                }
           }
        }
       }.resume()
       
   }

    

 func log( request: URLRequest? , responce : Any?){
    
    guard let url = request?.url?.absoluteString , let httpGeaders = request?.allHTTPHeaderFields , let data =  request?.httpBody , let dataString = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers])as? [String:AnyObject] else {
        return
    }
    guard   let response = responce else {
        print(url , httpGeaders, dataString)
               return
    }
    
    if let responseString = response as? String{
        print(url , httpGeaders, dataString ,responseString)
    }
    
    if let data = response as? Data , let json = (try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers])) as? [String:Any]{
        
        print(url , httpGeaders, dataString ,json)

    }
    else{
        print(url , httpGeaders, dataString)
    }
   
}
    
    func showProgress (){
//showProgress()
    }
    
    func hideProgress (){
       // ProgressBar.hide()
    }
    
    
        
}
