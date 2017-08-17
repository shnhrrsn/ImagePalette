//
//  AlbumLoader.swift
//  Palette
//
//  Created by Shaun Harrison on 8/16/17.
//  Copyright © 2017 shnhrrsn. All rights reserved.
//

import UIKit

private let topAlbums = URL(string: "https://itunes.apple.com/us/rss/topalbums/limit=25/json")!
private typealias JsonObject = [String: Any]

struct AlbumLoader {
	typealias Completion = ([Album]?) -> Void

	static func load(_ completion: @escaping Completion) {
		let mainCompletion: Completion = { images in
			DispatchQueue.main.async {
				completion(images)
			}
		}

		URLSession.shared.dataTask(with: topAlbums) { (data, response, error) in
			guard let data = data, let response = (response as? HTTPURLResponse), response.statusCode == 200 else {
				print("Failed to load album JSON: \(String(describing: error))")
				return mainCompletion(nil)
			}

			guard let json = try? JSONSerialization.jsonObject(with: data, options: [ ]) as? JsonObject else {
				print("Failed to parse album JSON")
				return mainCompletion(nil)
			}

			guard let entries = (json?["feed"] as? JsonObject)?["entry"] as? [JsonObject], entries.count > 0 else {
				print("Failed to detect albums")
				return mainCompletion(nil)
			}

			var rank = 0

			let albums: [Album] = entries.flatMap {
				guard let artwork = ($0["im:image"] as? [JsonObject])?.first?["label"] as? String else {
					return nil
				}

				guard let name = ($0["im:name"] as? JsonObject)?["label"] as? String else {
					return nil
				}

				guard let url = URL(string: artwork) else {
					return nil
				}

				rank += 1

				return Album(name: name, rank: rank, artworkUrl: url, artwork: nil)
			}

			self.load(albums: albums, completion: mainCompletion)
		}.resume()
	}

	private static func load(albums: [Album], completion: @escaping Completion) {
		guard albums.count > 0 else {
			print("No valid albums to load")
			return completion(nil)
		}

		var loadedAlbums = [Album]()
		let group = DispatchGroup()

		for album in albums {
			group.enter()

			album.loadArtwork {
				defer {
					group.leave()
				}

				guard let artwork = $0 else {
					return
				}

				var album = album
				album.artwork = artwork
				loadedAlbums.append(album)
			}
		}

		group.notify(queue: DispatchQueue.main, work: DispatchWorkItem {
			guard loadedAlbums.count > 0 else {
				print("Failed to load any albums")
				return completion(nil)
			}

			completion(loadedAlbums)
		})
	}

}
