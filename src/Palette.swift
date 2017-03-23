//
//  Palette.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

private func createQueue() -> dispatch_queue_t {
	let queue = dispatch_queue_create("palette.generator", DISPATCH_QUEUE_CONCURRENT)
	dispatch_set_target_queue(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), queue)
	return queue
}

public final class Palette {
	static var internalQueue = createQueue()
	
	/** All of the swatches which make up the palette */
	public let swatches: [PaletteSwatch]
	private let generator: PaletteGenerator

	private init(swatches: [PaletteSwatch], generator: PaletteGenerator) {
		self.swatches = swatches
		self.generator = generator
	}

	/**
	Create a palette synchronously.
	*/
	public convenience init(configuration: PaletteConfiguration) {
		let (swatches, generator) = configuration.generate()
		self.init(swatches: swatches, generator: generator)
	}

	public static func generateWithConfiguration(configuration: PaletteConfiguration, completion: (Palette) -> Void) {
		self.generateWithConfiguration(configuration, queue: self.internalQueue, completion: completion)
	}

	public static func generateWithConfiguration(configuration: PaletteConfiguration, queue: dispatch_queue_t, completion: (Palette) -> Void) {
		dispatch_async(queue) {
			let (swatches, generator) = configuration.generate()
			let palette = self.init(swatches: swatches, generator: generator)

			dispatch_async(dispatch_get_main_queue()) {
				completion(palette)
			}
		}
	}

	/** The most vibrant swatch in the palette. */
	public var vibrantSwatch: PaletteSwatch? {
		return self.generator.vibrantSwatch
	}

	/** Light and vibrant swatch from the palette. */
	public var lightVibrantSwatch: PaletteSwatch? {
		return self.generator.lightVibrantSwatch
	}

	/** Dark and vibrant swatch from the palette. */
	public var darkVibrantSwatch: PaletteSwatch? {
		return self.generator.darkVibrantSwatch
	}

	/** Muted swatch from the palette. */
	public var mutedSwatch: PaletteSwatch? {
		return self.generator.mutedSwatch
	}

	/** Muted and light swatch from the palette. */
	public var lightMutedSwatch: PaletteSwatch? {
		return self.generator.lightMutedSwatch
	}

	/** Muted and dark swatch from the palette. */
	public var darkMutedSwatch: PaletteSwatch? {
		return self.generator.darkMutedSwatch
	}

	/**
	Returns the most vibrant color in the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func vibrantColor(defaultColor: UIColor) -> UIColor {
		if let swatch = self.vibrantSwatch {
			return swatch.color
		} else {
			return defaultColor
		}
	}

	/**
	Returns a light and vibrant color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func lightVibrantColor(defaultColor: UIColor) -> UIColor {
		if let swatch = self.lightVibrantSwatch {
			return swatch.color
		} else {
			return defaultColor
		}
	}

	/**
	Returns a dark and vibrant color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func darkVibrantColor(defaultColor: UIColor) -> UIColor {
		if let swatch = self.darkVibrantSwatch {
			return swatch.color
		} else {
			return defaultColor
		}
	}

	/**
	Returns a muted color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func mutedColor(defaultColor: UIColor) -> UIColor {
		if let swatch = self.mutedSwatch {
			return swatch.color
		} else {
			return defaultColor
		}
	}

	/**
	Returns a muted and light color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func lightMutedColor(defaultColor: UIColor) -> UIColor {
		if let swatch = self.lightMutedSwatch {
			return swatch.color
		} else {
			return defaultColor
		}
	}

	/**
	Returns a muted and dark color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func darkMutedColor(defaultColor: UIColor) -> UIColor {
		if let swatch = self.darkMutedSwatch {
			return swatch.color
		} else {
			return defaultColor
		}
	}

}
