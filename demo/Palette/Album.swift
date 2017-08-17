//
//  Album.swift
//  Palette
//
//  Created by Shaun Harrison on 8/16/17.
//  Copyright © 2017 shnhrrsn. All rights reserved.
//

import UIKit

struct Album {

	var name: String
	var rank: Int
	var artworkUrl: URL
	var artwork: UIImage?

	func loadArtwork(completion: @escaping (UIImage?) -> Void) {
		if let artwork = self.artwork {
			return completion(artwork)
		}

		URLSession.shared.dataTask(with: self.artworkUrl) { (data, response, error) in
			guard let data = data, let image = UIImage(data: data) else {
				print("Failed to load album artwork: \(self) - \(String(describing: error))")
				return completion(nil)
			}

			completion(image)
		}.resume()
	}

}

extension Album: Comparable {

	static func ==(lhs: Album, rhs: Album) -> Bool {
		return lhs.rank == rhs.rank
	}

	static func <(lhs: Album, rhs: Album) -> Bool {
		return lhs.rank < rhs.rank
	}

}
