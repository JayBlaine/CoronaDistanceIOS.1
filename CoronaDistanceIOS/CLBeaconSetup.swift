//
//  CLBeaconSetup.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import SwiftUI
import CoreLocation
import CoreBluetooth




//let userLocationAccess = CoreLocation.req

func monitorBeacons() {
    if CLLocationManager.isMonitoringAvailable(for:
                  CLBeaconRegion.self) {
        // Match all beacons with the specified UUID
        let proximityUUID = UUID(uuidString:
               "39ED98FF-2900-441A-802F-9C398FC199D2")
        let beaconID = "com.example.myBeaconRegion"
            
        // Create the region and begin monitoring it.
        let region = CLBeaconRegion(proximityUUID: proximityUUID!,
               identifier: beaconID)
        self.locationManager.startMonitoring(for: region)
    }
}

func locationManager(_ manager: CLLocationManager,
            didEnterRegion region: CLRegion) {
    if region is CLBeaconRegion {
        // Start ranging only if the devices supports this service.
        if CLLocationManager.isRangingAvailable() {
            manager.startRangingBeacons(in: region as! CLBeaconRegion)

            // Store the beacon so that ranging can be stopped on demand.
            beaconsToRange.append(region as! CLBeaconRegion)
        }
    }
}

func locationManager(_ manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion) {
if beacons.count > 0 {
    let nearestBeacon = beacons.first!
    let major = CLBeaconMajorValue(nearestBeacon.major)
    let minor = CLBeaconMinorValue(nearestBeacon.minor)
        
    switch nearestBeacon.proximity {
    case .near, .immediate:
        // Display information about the relevant exhibit.
        displayInformationAboutExhibit(major: major, minor: minor)
        break
            
    default:
       // Dismiss exhibit information, if it is displayed.
       dismissExhibit(major: major, minor: minor)
       break
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
