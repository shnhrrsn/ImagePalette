//
//  PalleteiOS.swift
//  POCLatestFeedBackground
//
//  Created by Apinun Wongintawang on 6/14/19.
//  Copyright © 2019 Apinun Wongintawang. All rights reserved.
//

import UIKit

extension UIView {
    public func generateColorBy(img: UIImage?, path: String, defaultColor: UIColor?, complete: ((_ color: UIColor) -> Void)?) {
        //set default color when user is not take default color.
        let _defaultColor: UIColor   = defaultColor ?? .lightGray
        
        guard let _img = img else {
            self.setUpBackgroudColor(color: _defaultColor)
            return
        }
        
        //Get color from cache
        if let color = ColorBGPalleteCache.shared.getColor(key: path) {
            self.setUpBackgroudColor(color: color)
            return
        }
        
        //Resize image
        let newSize = getSizeOfImageFromDisplay(size: _img.size)
        let imageSmall = _img.resized(to: newSize)
        
        DispatchQueue.global(qos: .userInteractive).async {
            var config =  PaletteConfiguration(image: imageSmall)
            let maxColor = PalleteConfig.maxColor
            
            config.maxColors = maxColor
            
            Palette.generateWith(configuration: config, completion: { (pallette) in
                if let palleteColor = pallette.darkVibrantSwatch?.color {
                    self.addColorToCache(color: palleteColor, path: path)
                    self.setUpBackgroudColor(color: palleteColor)
                    complete?(palleteColor)
                } else {
                    self.addColorToCache(color: _defaultColor, path: path)
                    self.setUpBackgroudColor(color: _defaultColor)
                    complete?(_defaultColor)
                }
                self.layoutIfNeeded()
                self.setNeedsDisplay()
            })
        }
    }
    
    private func addColorToCache(color: UIColor, path: String) {
        guard !path.isEmpty else { return }
        
        //save color to cache
        ColorBGPalleteCache.shared.addColor(key: path, color: color)
    }
    
    private func setUpBackgroudColor(color: UIColor) {
        DispatchQueue.main.async {
            self.backgroundColor = color
        }
    }
    
    private func getSizeOfImageFromDisplay(size: CGSize) -> CGSize {
        let ratio = size.width / size.height
        let screenSize = UIScreen.main.bounds
        let newSize = CGSize(width: screenSize.size.width, height: screenSize.size.width/ratio)
        return newSize
    }
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
