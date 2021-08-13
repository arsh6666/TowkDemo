//
//  UserProfileVC.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import UIKit

class UserProfileVC: UIViewController{
    var userName : String!
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    private var userProfileViewModel : UserProfileViewModel!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var noteView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        noteView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        self.title = userName
        self.userProfileViewModel = UserProfileViewModel.init(viewcontroller: self, userName: userName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                  
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.userProfileViewModel.saveProfileDetail(isSave: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
