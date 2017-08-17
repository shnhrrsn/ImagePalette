//
//  DemoViewController.swift
//  Palette
//
//  Created by Shaun Harrison on 8/20/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

import UIKit

struct RowItem {
	var album: Album
	var palette: Palette
}

class DemoViewController: UITableViewController {
	var rows = [RowItem]()

	var brightnessSegmentedControl = UISegmentedControl(items: [
		"Light",
		"Normal",
		"Dark"
	])

	var vibrancySegmentedControl = UISegmentedControl(items: [
		"Vibrant",
		"Muted"
	])

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Loading"

		self.tableView.backgroundColor = UIColor.black
		self.tableView.separatorStyle = .none
		self.tableView.register(DemoTableViewCell.self, forCellReuseIdentifier: "cell")

		self.brightnessSegmentedControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
		self.brightnessSegmentedControl.selectedSegmentIndex = 0

		self.vibrancySegmentedControl.selectedSegmentIndex = 1
		self.vibrancySegmentedControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)

		print("Loading albums and artwork")

		AlbumLoader.load {
			guard let albums = $0, albums.count > 0 else {
				print("Failed to load images")
				return
			}

			self.rows.removeAll()
			let group = DispatchGroup()

			for album in albums {
				guard let artwork = album.artwork else {
					continue
				}

				let config = PaletteConfiguration(image: artwork)
				group.enter()

				Palette.generateWith(configuration: config) {
					self.rows.append(RowItem(album: album, palette: $0))
					group.leave()
				}
			}

			group.notify(queue: DispatchQueue.main, work: DispatchWorkItem {
				self.rows.sort { $0.album < $1.album }
				self.tableView.reloadData()

				self.title = nil
				self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.brightnessSegmentedControl)
				self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.vibrancySegmentedControl)
			})
		}
	}

	@objc
	func reloadTableView() {
		self.tableView.reloadData()
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.rows.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DemoTableViewCell
		cell.textLabel?.text = self.rows[indexPath.row].album.name
		cell.imageView?.image = self.rows[indexPath.row].album.artwork

		let palette = self.rows[indexPath.row].palette
		let isVibrant = self.vibrancySegmentedControl.selectedSegmentIndex == 0
		let swatch: PaletteSwatch?

		switch self.brightnessSegmentedControl.selectedSegmentIndex {
			case 0:
				swatch = isVibrant ? palette.lightVibrantSwatch : palette.lightMutedSwatch
			case 1:
				swatch = isVibrant ? palette.vibrantSwatch : palette.mutedSwatch
			case 2:
				swatch = isVibrant ? palette.darkVibrantSwatch : palette.darkMutedSwatch
			default:
				swatch = nil
		}

		cell.swatch = swatch

		return cell
	}

	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return false
	}

}

