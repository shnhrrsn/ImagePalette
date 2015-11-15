//
//  UIImage+PaletteExtension.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

extension UIImage {

	/**
	Scale the image down so that it's largest dimension is targetMaxDimension.
	If image is smaller than this, then it is returned.
	*/
	internal func scaleDown(targetMaxDimension: CGFloat) -> UIImage? {
		let size = self.size
		let maxDimensionInPoints = max(size.width, size.height)
		let maxDimensionInPixels = maxDimensionInPoints * self.scale

		if maxDimensionInPixels <= targetMaxDimension {
			// If the bitmap is small enough already, just return it
			return self
		}

		let scaleRatio = targetMaxDimension / maxDimensionInPoints
		let width = round(size.width * scaleRatio)
		let height = round(size.height * scaleRatio)

		UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), true, 1.0)
		self.drawInRect(CGRectMake(0.0, 0.0, width, height))
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return scaledImage
	}

	internal var pixels: Array<Int> {
		let image = self.CGImage!

		let pixelsWide = CGImageGetWidth(image)
		let pixelsHigh = CGImageGetHeight(image)

		let bitmapBytesPerRow = (pixelsWide * 4)
		let bitmapByteCount = (bitmapBytesPerRow * pixelsHigh)

		if let colorSpace = CGColorSpaceCreateDeviceRGB() {
			let bitmapData = malloc(bitmapByteCount)
			defer { free(bitmapData) }

			if let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue) {
				CGContextDrawImage(context, CGRectMake(0.0, 0.0, CGFloat(pixelsWide), CGFloat(pixelsHigh)), image)

				let unconstrainedData = CGBitmapContextGetData(context)
				let data = UnsafePointer<UInt8>(unconstrainedData)
				var pixels = Array<Int>()

				for var x = 0; x < pixelsWide; x++ {
					for var y = 0; y < pixelsHigh; y++ {
						let pixelInfo = ((pixelsWide * y) + x) * 4

						let alpha = Int(data[pixelInfo])
						let red = Int(data[pixelInfo + 1])
						let green = Int(data[pixelInfo + 2])
						let blue = Int(data[pixelInfo + 3])

						pixels.append(HexColor.fromARGB(alpha, red: red, green: green, blue: blue))
					}
				}

				return pixels
			} else {
				fatalError("Unable to create bitmap context!")
			}
		} else {
			fatalError("Unable to allocate color space")
		}

	}

}