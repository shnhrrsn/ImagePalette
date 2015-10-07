//
//  ColorHistogram.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

/**
Class which provides a histogram for RGB values.
*/
public class ColorHistogram {

	/**
	An array containing all of the distinct colors in the image.
	*/
	private(set) public var colors = Array<Int>()

	/**
	An array containing the frequency of a distinct colors within the image.
	*/
	private(set) public var colorCounts = Array<Int>()

	/**
	Number of distinct colors in the image.
	*/
	private(set) public var numberOfColors: Int

	/**
	A new ColorHistogram instance.

	:param: Pixels array of image contents
	*/
	public init(var pixels: [Int]) {
		// Sort the pixels to enable counting below
		pixels.sortInPlace()

		// Count number of distinct colors
		self.numberOfColors = self.dynamicType.countDistinctColors(pixels)

		// Finally count the frequency of each color
		self.countFrequencies(pixels)
	}

	private static func countDistinctColors(pixels: [Int]) -> Int {
		if pixels.count < 2 {
			// If we have less than 2 pixels we can stop here
			return pixels.count
		}

		// If we have at least 2 pixels, we have a minimum of 1 color...
		var colorCount = 1
		var currentColor = pixels[0]

		// Now iterate from the second pixel to the end, counting distinct colors
		for pixel in pixels {
			// If we encounter a new color, increase the population
			if pixel != currentColor {
				currentColor = pixel
				colorCount++
			}
		}

		return colorCount
	}

	private func countFrequencies(pixels: [Int]) {
		if pixels.count == 0 {
			return
		}

		var currentColorIndex = 0
		var currentColor = pixels[0]

		self.colors.append(currentColor)
		self.colorCounts.append(1)

		if pixels.count == 1 {
			// If we only have one pixel, we can stop here
			return
		}

		// Now iterate from the second pixel to the end, population distinct colors
		for pixel in pixels {
			if pixel == currentColor {
				// We've hit the same color as before, increase population
				self.colorCounts[currentColorIndex]++
			} else {
				// We've hit a new color, increase index
				currentColor = pixel

				currentColorIndex++
				self.colors.append(currentColor)
				self.colorCounts.append(1)
			}
		}
	}
	
}
