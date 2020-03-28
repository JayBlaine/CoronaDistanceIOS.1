//
//  AppDelegate.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	let locationManager = CLLocationManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		locationManager.delegate = self
		//Request permission to send notifications
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in}
		
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
// MARK: CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
//prompts the notification based on action "didEnterRegion"
func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLBeaconRegion)
		{
			guard region is CLBeaconRegion else { return }
			
			let content = UNMutableNotificationContent()
			content.title = "Oops I'm too close"
			content.body = "Get away from me now! Do you want to die or something?"
			content.sound = .default
			
			let request = UNNotificationRequest(identifier: "Close", content: content, trigger: nil)
			UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
		}
}



