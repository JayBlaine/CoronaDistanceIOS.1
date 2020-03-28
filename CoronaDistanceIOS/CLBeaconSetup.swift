//
//  CLBeaconSetup.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import SwiftUI
import CoreLocation

protocol CLLocationManagerDelegate {}

var locationManager: CLLocationManager!
var iBeaconNear = false

func viewDidLoad() {
    //super.viewDidLoad()

    locationManager = CLLocationManager()
    //locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
}

func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            if CLLocationManager.isRangingAvailable() {
                startScanning()
            }
        }
    }
}

func startScanning() {
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

    locationManager.startMonitoring(for: beaconRegion)
    locationManager.startRangingBeacons(in: beaconRegion)
}

func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if beacons.count > 0 {
        updateDistance(beacons[0].proximity)
    } else {
        updateDistance(.unknown)
    }
	/*
	let content = UNMutableNotificationContent()
		content.title = "Forget Me Not"
		content.body = "Are you forgetting something?"
		content.sound = .default()
    
	let request = UNNotificationRequest(identifier: "ForgetMeNot", content: content, trigger: nil)
	UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
	*/
}

func updateDistance(_ distance: CLProximity) {
        switch distance {
        case .unknown:
            return

        case .far:
            return

        case .near:
            iBeaconNear = true

        case .immediate:
            iBeaconNear = true
        @unknown default:
            return
        }
    
}






