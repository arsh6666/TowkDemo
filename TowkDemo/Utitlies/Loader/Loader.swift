//
//  Loader.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 10/08/21.
//

import Foundation
import UIKit

fileprivate var aView:UIView?

extension UIViewController {
    func show(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView.init(style:.large)
        ai.color = UIColor.blue
        ai.center = aView!.center
        ai.startAnimating()
        
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    func hide(){
        aView?.removeFromSuperview()
        aView = nil
        
    }
}
