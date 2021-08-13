//
//  Extensions.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 11/08/21.
//

import Foundation
import UIKit

extension UIImage {
    func inverseImage() -> UIImage? {
        
        let beginImage = CIImage(image: self)
               if let filter = CIFilter(name: "CIColorInvert") {
                   filter.setValue(beginImage, forKey: kCIInputImageKey)
                let newImage = UIImage(ciImage: filter.outputImage!)
                   return newImage
               }
        return nil

    }
}
