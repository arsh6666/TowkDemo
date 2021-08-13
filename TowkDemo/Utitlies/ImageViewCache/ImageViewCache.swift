//
//  ImageViewCache.swift
//  TowkDemo
//
//  Created by Arshdeep Singh on 11/08/21.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    
    // MARK: - Constants

    let imageCache = NSCache<NSString, AnyObject>()

    // MARK: - Properties

    var imageURLString: String?

    func downloadImageFrom(urlString: String, isInverted:Bool, isRounded:Bool = true) {
        if isRounded {
            self.layer.cornerRadius = self.frame.width/2;
            self.clipsToBounds = true
        }
        
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url,isInverted: isInverted )
    }

    func downloadImageFrom(url: URL, isInverted:Bool) {
        
        contentMode = UIView.ContentMode.scaleToFill
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            if(isInverted){
                self.image = cachedImage.inverseImage()
            }
            else{
                self.image = cachedImage
            }
            
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return}
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    if(isInverted){
                        self.image = imageToCache!.inverseImage()
                    }
                    else{
                        self.image = imageToCache
                    }
                }
            }.resume()
        }
    }
}
