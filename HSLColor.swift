//
//  HSL.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

internal class HSLColor {
	final let hue: CGFloat
	final let saturation: CGFloat
	final let lightness: CGFloat
	final let alpha: CGFloat

	private var _rgb: RGBColor?

	init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
		self.hue = hue
		self.saturation = saturation
		self.lightness = lightness
		self.alpha = alpha
	}

	var color: UIColor {
		return self.rgb.color
	}

	var rgb: RGBColor {
		if let rgb = self._rgb {
			return rgb
		} else {
			let c = (1.0 - abs(2 * self.lightness - 1.0)) * self.saturation
			let m = self.lightness - 0.5 * c
			let x = c * (1.0 - abs((self.hue / 60.0 % 2.0) - 1.0))

			let hueSegment = Int(self.hue / 60.0)

			var r = 0
			var g = 0
			var b = 0

			switch hueSegment {
				case 0:
					r = Int(round(255 * (c + m)))
					g = Int(round(255 * (x + m)))
					b = Int(round(255 * m))
				case 1:
					r = Int(round(255 * (x + m)))
					g = Int(round(255 * (c + m)))
					b = Int(round(255 * m))
				case 2:
					r = Int(round(255 * m))
					g = Int(round(255 * (c + m)))
					b = Int(round(255 * (x + m)))
				case 3:
					r = Int(round(255 * m))
					g = Int(round(255 * (x + m)))
					b = Int(round(255 * (c + m)))
				case 4:
					r = Int(round(255 * (x + m)))
					g = Int(round(255 * m))
					b = Int(round(255 * (c + m)))
				case 5, 6:
					r = Int(round(255 * (c + m)))
					g = Int(round(255 * m))
					b = Int(round(255 * (x + m)))
				default:
					break
			}

			r = max(0, min(255, r))
			g = max(0, min(255, g))
			b = max(0, min(255, b))

			let rgb = RGBColor(red: r, green: g, blue: b, alpha: Int(round(self.alpha * 255)))
			self._rgb = rgb
			return rgb
		}
	}

	internal func colorWithLightnessComponent(lightness: CGFloat) -> HSLColor {
		return HSLColor(hue: self.hue, saturation: self.saturation, lightness: self.lightness, alpha: self.alpha)
	}

}
