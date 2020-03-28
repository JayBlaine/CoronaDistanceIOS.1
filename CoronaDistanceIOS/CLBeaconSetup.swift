//
//  CLBeaconSetup.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import SwiftUI
import CoreLocation

var locationManager: CLLocationManager!

override func viewDidLoad() {
    super.viewDidLoad()

    locationManager = CLLocationManager()
    locationManager.delegate = self
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
}

func updateDistance(_ distance: CLProximity) {
    UIView.animate(withDuration: 0.8) {
        switch distance {
        case .unknown:
            self.view.backgroundColor = UIColor.gray

        case .far:
            self.view.backgroundColor = UIColor.blue

        case .near:
            self.view.backgroundColor = UIColor.orange

        case .immediate:
            self.view.backgroundColor = UIColor.red
        }
    }
}




struct CLBeaconSetup: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


    //PREVIEW BELOW

 

struct CLBeaconSetup_Previews: PreviewProvider {
    static var previews: some View {
        CLBeaconSetup()
    }
}
