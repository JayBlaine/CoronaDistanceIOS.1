//
//  AppDelegate.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//	Edited by Patrick Valadez
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
//change this to prompt on global variable change for beacon detection
func locationManager(_ manager: CLLocationManager, iBeaconNear: Bool)
		{
			//ard region is CLBeaconRegion else { return }
			if iBeaconNear
			{
			let content = UNMutableNotificationContent()
			content.title = "Oops"
			content.body = "You're too close to another person "
			content.sound = .default
			
			let request = UNNotificationRequest(identifier: "Close", content: content, trigger: nil)
			UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
			}
	}
		
}




struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
