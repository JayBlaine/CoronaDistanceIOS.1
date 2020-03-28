//
//  CLBeaconSetup.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import SwiftUI
import CoreLocation

struct CLBeaconSetup: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


//let userLocationAccess =

func createBeaconRegion() -> CLBeaconRegion? {
    let proximityUUID = UUID(uuidString:
                "39ED98FF-2900-441A-802F-9C398FC199D2")
    let major : CLBeaconMajorValue = 100
    let minor : CLBeaconMinorValue = 1
    let beaconID = "com.example.myDeviceRegion"
        
    return CLBeaconRegion(proximityUUID: proximityUUID!,
                major: major, minor: minor, identifier: beaconID)
}

func advertiseDevice(region : CLBeaconRegion) {
    let peripheral = CBPeripheralManager(delegate: self, queue: nil)
    let peripheralData = region.peripheralData(withMeasuredPower: nil)
        
    peripheral.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
}






    //PREVIEW BELOW

 

struct CLBeaconSetup_Previews: PreviewProvider {
    static var previews: some View {
        CLBeaconSetup()
    }
}
