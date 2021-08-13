//
//  NormalTableViewCell.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 11/08/21.
//

import UIKit

class NormalTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDisc: UILabel!
    @IBOutlet weak var hStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ConfigureCell(userData:User,isInverted:Bool) {
        self.imgUser.downloadImageFrom(urlString: userData.avatarURL!, isInverted:isInverted)
        self.lblUserName.text = userData.login;
        self.lblDisc.text = userData.type
        if(userData.notes == nil || userData.notes!.isEmpty){
            hStack.arrangedSubviews[2].isHidden = true
        }
        else{
            hStack.arrangedSubviews[2].isHidden = false
        }
        
        if userData.siteAdmin ?? false {
            self.backgroundColor = UIColor.gray
        }
        else{
            self.backgroundColor = UIColor.white
        }
    }
    
}
