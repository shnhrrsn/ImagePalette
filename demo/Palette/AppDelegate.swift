//
//  AppDelegate.swift
//  Palette
//
//  Created by Shaun Harrison on 8/20/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		let viewController = DemoViewController()
		let navigationController = UINavigationController(rootViewController: viewController)
		navigationController.navigationBar.barStyle = .black

		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = navigationController
		window.tintColor = .white
		window.makeKeyAndVisible()

		self.window = window
		
		return true
	}

}

