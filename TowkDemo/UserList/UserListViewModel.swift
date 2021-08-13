//
//  UserListViewModel.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import Foundation
import UIKit
import CoreData

class UserListViewModel : NSObject{
    private var webClient : ApiClient!
    var sinceVal:Int!
    
    var context : NSManagedObjectContext!
    var userList:[User] = []
    var userListTemp:[User] = []
    
    override init() {
        super.init()
        sinceVal = 0
        self.webClient = ApiClient()
        let appDelegate = AppDelegate.shared
        self.context = appDelegate.persistentContainer.viewContext
        userList = []
    }
    
    func GetUserListMethod(completionUsers:@escaping(Bool)->(Void)) {
        
        if(sinceVal > 0){
            CallGetUserListApi(completion: {success in
                if(success){
                    completionUsers(true)
                }
            })
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let login : String = data.value(forKey: "login") as! String
                let avatarURL : String = data.value(forKey: "avatarURL") as! String
                let type : String = data.value(forKey: "type") as! String
                let notes : String = (data.value(forKey: "notes") ?? "") as! String
                let id : Int = data.value(forKey: "id") as! Int
                let follower : Int = (data.value(forKey: "follower") ?? 0) as! Int
                let following : Int = (data.value(forKey: "following") ?? 0)as! Int
                let blog : String = (data.value(forKey: "blog") ?? "") as! String
                let company : String = (data.value(forKey: "company") ?? "") as! String
                let siteAdmin : Bool = data.value(forKey: "siteAdmin") as! Bool
                
                let myUser = User.init(login: login,name: "", id: id, follower: follower, following: following, avatarURL: avatarURL,type: type,blog: blog,company: company,siteAdmin:siteAdmin,notes:notes)
                userList.append(myUser)
                           
            }
            
            if(userList.count == 0){
                CallGetUserListApi(completion: {success in
                    if(success){
                        completionUsers(true)
                    }
                })
            }
            else{
                sinceVal = userList.last?.id
                completionUsers(true)
            }
            
        } catch {
            print("Failed")
        }
        
        
        
    }
    
    
    func CallGetUserListApi(completion:@escaping(Bool)->(Void))
    {
    
        guard let resorce = ApiResource.getUserListResource(since: sinceVal) else{
                return
            }
            
            self.webClient.load(resource: resorce) {[weak self]result in
                
                switch result
                {
                    case .success(let responseResult):
                        
                        if  responseResult.count > 0 {
                            self?.userList.append(contentsOf: responseResult)
                            self?.SaveUserListMethod(users: responseResult)
                            self?.sinceVal = responseResult.last?.id
                            
                            completion(true)
                        }
                        else{
                            ApplicationSession.ShowAlertMethod(message:"Something went wrong")
                            completion(false)
                        }
                        
                        break
                    case .failure(_):
                        
                        ApplicationSession.ShowAlertMethod(message:"Something went wrong")
                        completion(false)
                        break
                    }
                }
    }
    
    func SaveUserListMethod(users:[User]){
        
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        
        for user in users {
            let newUser = NSManagedObject(entity: entity!, insertInto: context) as! Users
            newUser.login = user.login
            newUser.avatarURL = user.avatarURL
            newUser.id = Int16(user.id ?? 0)
            newUser.type = user.type
            newUser.siteAdmin = user.siteAdmin ?? false
//            newUser.setValue(user.login, forKey: "login")
//            newUser.setValue(user.avatarURL, forKey: "avatarURL")
//            newUser.setValue(user.id, forKey: "id")
//            newUser.setValue(user.type, forKey: "type")
//            newUser.setValue(user.siteAdmin, forKey: "siteAdmin")


            do {
               try context.save()
              } catch {
               print("Failed saving")
            }
        }
        
        
    }

    
}
