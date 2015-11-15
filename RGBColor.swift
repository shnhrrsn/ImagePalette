//
//  RGB.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

internal class RGBColor: Hashable, Equatable {
	final let red: Int
	final let green: Int
	final let blue: Int
	final let alpha: Int
	final let hashValue: Int

	init(red: Int, green: Int, blue: Int, alpha: Int) {
		self.red = red
		self.green = green
		self.blue = blue
		self.alpha = alpha
		self.hashValue = (alpha << 24) | (red << 16) | (green << 8) | blue
	}

	convenience init(color: UIColor) {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0

		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		self.init(red: Int(round(red * 255.0)), green: Int(round(green * 255.0)), blue: Int(round(blue * 255.0)), alpha: Int(round(alpha * 255.0)))
	}

	var color: UIColor {
		return UIColor(red: CGFloat(self.red) / 255.0, green: CGFloat(self.green) / 255.0, blue: CGFloat(self.blue) / 255.0, alpha: CGFloat(self.alpha) / 255.0)
	}

	var hex: Int {
		return HexColor.fromRGB(self.red, green: self.green, blue: self.blue)
	}

	var hsl: HSLColor {
		let rf = CGFloat(self.red) / 255.0
		let gf = CGFloat(self.green) / 255.0
		let bf = CGFloat(self.blue) / 255.0

		let maxValue = max(rf, max(gf, bf))
		let minValue = min(rf, min(gf, bf))
		let deltaMaxMin = maxValue - minValue

		var h: CGFloat
		var s: CGFloat
		let l = (maxValue + minValue) / 2.0

		if maxValue == minValue {
			// Monochromatic
			h = 0.0
			s = 0.0
		} else {
			if maxValue == rf {
				h = ((gf - bf) / deltaMaxMin) % 6.0
			} else if maxValue == gf {
				h = ((bf - rf) / deltaMaxMin) + 2.0
			} else {
				h = ((rf - gf) / deltaMaxMin) + 4.0
			}

			s = deltaMaxMin / (1.0 - abs(2.0 * l - 1.0))
		}

		return HSLColor(hue: (h * 60.0) % 360.0, saturation: s, lightness: l, alpha: CGFloat(self.alpha) / 255.0)
	}

}

internal func ==(lhs: RGBColor, rhs: RGBColor) -> Bool {
	return lhs.hashValue == rhs.hashValue
}
