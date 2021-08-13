//
//  shimmer.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 11/08/21.
//

import Foundation
import UIKit

class Shimmer: UIView {
    var gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
    
   
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        startAnimating()
    }
    
    func startAnimating() {
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        
        let gradientLayer = CAGradientLayer()
        /* Allocate the frame of the gradient layer as the view's bounds, since the layer will sit on top of the view. */
          
          gradientLayer.frame = self.bounds
        /* To make the gradient appear moving from left to right, we are providing it the appropriate start and end points.
        */
          gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
          gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
          gradientLayer.colors = [gradientColorOne, gradientColorTwo,   gradientColorOne]
          gradientLayer.locations = [0.0, 0.5, 1.0]
        
        gradientLayer.add(animation, forKey: animation.keyPath)
        
        /* Adding the gradient layer on to the view */
          self.layer.addSublayer(gradientLayer)
    }
}
