//
//  UserListVC.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import UIKit
import Network

class UserListVC: UIViewController,NetworkCheckObserver {
    
    
    
    let networkCheck = NetworkCheck.sharedInstance()
    
    @IBOutlet weak var tblUsers: UITableView!
    private var userListViewModel : UserListViewModel!
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var hStack: UIStackView!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUsers.register(UINib.init(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "UserFoundCell")
        tblUsers.register(UINib.init(nibName: "ShimmerTableViewCell", bundle: nil), forCellReuseIdentifier: "shimmerCell")
        self.userListViewModel = UserListViewModel();
        
        
        
        hStack.arrangedSubviews[1].isHidden = true
                
        networkCheck.addObserver(observer: self)
        // Do any additional setup after loading the view.
    }
    
    func statusDidChange(status: NWPath.Status) {
        if networkCheck.currentStatus == .satisfied{
            ApplicationSession.ShowAlertMethod(message: "Internet Not Found")
        }
        else{
            ApplicationSession.ShowAlertMethod(message: "Internet Found")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userListViewModel.sinceVal = 0
        userListViewModel.userList = []
        getUserList()
    }
    
    @IBAction func txtValueChangedAction(_ sender: UITextField) {
        if(sender.text!.isEmpty){
            self.userListViewModel.userList = self.userListViewModel.userListTemp
        }
        else{
            let userListFiltter = self.userListViewModel.userListTemp.filter({ ($0.login?.contains(sender.text!))! || ("\($0.id ?? 0)".contains(sender.text!)) })
            
            if(userListFiltter.count == 0){
                self.tblUsers.isHidden = true
            }
            else{
                self.tblUsers.isHidden = false
            }
            
            self.userListViewModel.userList = userListFiltter
        }
        
        self.tblUsers.reloadData()
    }
    
    @IBAction func txtStartEditionAction(_ sender: UITextField) {
        btnSearch.isSelected = true
        hStack.arrangedSubviews[1].isHidden = false
    }
    
    func getUserList() {
        self.userListViewModel.GetUserListMethod(completionUsers: { value in
            self.userListViewModel.userListTemp = self.userListViewModel.userList
            self.tblUsers.reloadData()
        })
    }

    @IBAction func btnSearch(_ sender: UIButton) {
        self.view.endEditing(true)
        self.txtSearch.text = nil
        self.tblUsers.isHidden = false
        hStack.arrangedSubviews[1].isHidden = true
        self.userListViewModel.userList = self.userListViewModel.userListTemp
        self.tblUsers.reloadData()
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

extension UserListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userListViewModel.userList.count > 0 {
            return userListViewModel.userList.count
        }
        return Int(self.view.frame.height / 82 ) - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if userListViewModel.userList.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserFoundCell", for: indexPath) as! NormalTableViewCell
            let userData = userListViewModel.userList[indexPath.row]
                    
            if indexPath.row % 4 == 0 {
                cell.ConfigureCell(userData: userData,isInverted: true)
            }
            else{
                cell.ConfigureCell(userData: userData,isInverted: false)
            }
            return cell
        }

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shimmerCell", for: indexPath) as! ShimmerTableViewCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 82
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let userProfile = self.storyboard?.instantiateViewController(identifier: "UserProfileVC") as? UserProfileVC;
        userProfile!.userName = userListViewModel.userList[indexPath.row].login
        self.navigationController?.pushViewController(userProfile!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(self.btnSearch.isSelected){
            return
        }
        
        if(self.userListViewModel.userList.count > 0){
            let lastRowIndex = tableView.numberOfRows(inSection: 0)
                if indexPath.row == lastRowIndex - 1 {
                       getUserList()
                    let spinner = UIActivityIndicatorView(style: .medium)
                           spinner.startAnimating()
                           spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

                           self.tblUsers.tableFooterView = spinner
                           self.tblUsers.tableFooterView?.isHidden = false
                    }
        }
       
            
    }

}
