//
//  ColorBGPalleteCache.swift
//  POCLatestFeedBackground
//
//  Created by Apinun Wongintawang on 6/16/19.
//  Copyright © 2019 Apinun Wongintawang. All rights reserved.
//

import UIKit

class ColorBGPalleteCache {
    static let shared = ColorBGPalleteCache()
    var colorCache = NSCache<NSString, UIColor>()
    
    func addColor(key: String, color: UIColor) {
        colorCache.setObject(color, forKey: NSString(string: key))
    }
    
    func getColor(key: String) -> UIColor? {
        return colorCache.object(forKey: NSString(string: key))
    }
    
    func removeAllColor() {
        colorCache.removeAllObjects()
    }
}
