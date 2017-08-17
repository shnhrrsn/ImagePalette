//
//  DemoTableViewCell.swift
//  Palette
//
//  Created by Shaun Harrison on 8/20/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

import Foundation
import UIKit

class DemoTableViewCell: UITableViewCell {

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	var swatch: PaletteSwatch? {

		didSet {
			self.textLabel?.textColor = self.swatch?.titleTextColor ?? .clear
			self.backgroundColor = self.swatch?.color ?? .clear
		}

	}

}
