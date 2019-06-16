//
//  PalleteiOS.swift
//  POCLatestFeedBackground
//
//  Created by Apinun Wongintawang on 6/14/19.
//  Copyright © 2019 Apinun Wongintawang. All rights reserved.
//

import UIKit

extension UIView {
    func generateColorBy(img: UIImage, path: String, defaultColor: UIColor) {
        let newSize = getSizeOfImageFromDisplay(size: img.size)
        let imageSmall = img.resized(to: newSize)
        
        if let color = ColorBGPalleteCache.shared.getColor(key: path) {
            self.backgroundColor = color
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            var config =  PaletteConfiguration(image: imageSmall)
            let maxColor = 24
            
            config.maxColors = maxColor
            
            Palette.generateWith(configuration: config, completion: { (pallette) in
                if let palleteColor = pallette.lightVibrantSwatch?.color {
                    ColorBGPalleteCache.shared.addColor(key: path, color: palleteColor)
                    self.setUpBackgroudColor(color: palleteColor)
                } else {
                    self.setUpBackgroudColor(color: defaultColor)
                }
                self.layoutIfNeeded()
                self.setNeedsDisplay()
            })
        }
    }
    
    private func getSizeOfImageFromDisplay(size: CGSize) -> CGSize {
        let ratio = size.width / size.height
        let screenSize = UIScreen.main.bounds
        let newSize = CGSize(width: screenSize.size.width, height: screenSize.size.width/ratio)
        return newSize
    }
    
    private func setUpBackgroudColor(color: UIColor) {
        DispatchQueue.main.async {
            self.backgroundColor = color
        }
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
