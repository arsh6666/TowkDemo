//
//  UserProfileViewModel.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import Foundation
import UIKit
import CoreData

class UserProfileViewModel : NSObject{
    private var webClient : ApiClient!
    var _viewController :UserProfileVC!
    var _userName:String
    var context : NSManagedObjectContext!
    init(viewcontroller:UserProfileVC,userName:String) {
        
        _viewController = viewcontroller
        _userName = userName
        
    
        super.init()
        
        self.webClient = ApiClient()
        let appDelegate = AppDelegate.shared
        self.context = appDelegate.persistentContainer.viewContext
        
        saveProfileDetail(isSave: false)
        
        GetUserProfileDetail()
    }
    
    func GetUserProfileDetail(){
        
        CallGetUserDetailApi(completion: {sucess in
            
        })
    }
    
    func CallGetUserDetailApi(completion:@escaping(Bool)->(Void))
    {
        _viewController.show()
        guard let resorce = ApiResource.getUserDetailResource(username: _userName) else{
                return
            }
            
            self.webClient.load(resource: resorce) {[weak self]result in
                self?._viewController.hide()
                switch result
                {
                    case .success(let responseResult):
                        
                        if  responseResult.login != nil {
                            self?._viewController.imgUser.downloadImageFrom(urlString: responseResult.avatarURL!, isInverted: false,isRounded:false)
                            self?._viewController.lblName.text = responseResult.name
                            self?._viewController.lblCompany.text = responseResult.company
                            self?._viewController.lblBlog.text = responseResult.blog
                            self?._viewController.lblFollower.text =  String(describing: responseResult.follower ?? 0)
                            self?._viewController.lblFollowing.text = String(describing: responseResult.following ?? 0)
                            
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
    
    func saveProfileDetail(isSave:Bool){
        
        if self._viewController.txtNotes.text.isEmpty && isSave {
            ApplicationSession.ShowAlertMethod(message: "Please type notes")
            return
        }
        
        
        let user:Users
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            request.predicate = NSPredicate(format: "login = %@", _userName)
            request.returnsObjectsAsFaults = false
            let results = try context.fetch(request) as? [NSManagedObject]
            if results!.count > 0 {
                // here you are updating
                user = results?.first as! Users
                
                if(isSave){
                    user.notes = self._viewController.txtNotes.text
                }
                else{
                    self._viewController.txtNotes.text = user.notes
                }
                
                user.siteAdmin = true
             }
            try context.save()
            
            if(isSave){
                self._viewController.navigationController?.popViewController(animated: true)
                ApplicationSession.ShowAlertMethod(message: "Saved Successfully")
            }
            
        } catch {
            print("Failed")
        }
        
    }
    
    
    
}
