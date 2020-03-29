//
//  ContentView.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import SwiftUI

import CoreLocation
import Combine
import CoreBluetooth


//var locationManager: CLLocationManager!
var iBeaconNear = false
   
/*********
 MAYBE CHANGE
var didChange = PassthroughSubject<Void, Never>()  to  var didChange  = ObservableObjectPublisher()
and
didChange.send() to self.didChange.send()
 *********/


class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    var didChange = PassthroughSubject<Void, Never>()
    var locationManager: CLLocationManager?
    var lastDistance = CLProximity.unknown
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
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
        let uuid = UUID(uuidString: "35F9689E-21AF-444D-A700-B15f0C136804")!
        //Replace with either user input or random uuid generator, 5A4BCFCE PLACEHOLDER TODO
        //MAYBE MAKE !USER UUID
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 12300, minor: 45600)
        //Replace major/minor with user values, 123/456 PLACEHOLDER TODO
        //MAYBE MAKE !USER MAJOR/MINOR
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "Beacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
//    func advertiseDevice(region : CLBeaconRegion) {
//        let peripheral = CBPeripheralManager.self
//        let peripheralData = region.peripheralData(withMeasuredPower: nil)
//
//        peripheral.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
//    }
    
        
    func update(distance: CLProximity) {
        lastDistance = distance
        didChange.send()
    }
}

//class BeaconEmitter: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        <#code#>
//    }
//    var beacon: CLBeaconRegion!
//    var data: NSDictionary!
//    var peripheralManager: CBPeripheralManager!
//
//    func startBeacon() {
//        let UUID = "6B5CDERF-285F-5TAC-A814-092E88G6C8F6"
//        let major: CLBeaconMajorValue = 567
//        let minor: CLBeaconMinorValue = 987
//        beacon = CLBeaconRegion(proximityUUID:  NSUUID(uuidString: UUID)! as UUID, major: major, minor: minor, identifier: "IDENTIFIER")
//
//        data = beacon.peripheralData(withMeasuredPower: nil)
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
//    }
//
//}

 



struct ContentView: View {
    
    @State private var selection = 0
    @State private var searching = false
    @State var numbers: String = ""
    @State var major: String = ""
    @State var minor: String = ""
    @ObservedObject var detector = BeaconDetector()
    @State var UUIDReady: Bool = false
    @State var music: Bool = true
    @State private var isShowingAlert = false

    var body: some View {
        TabView(selection: $selection){
            
            //First Page Section
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(.black)
                    .edgesIgnoringSafeArea(.all)
            
                Rectangle()
                    .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255, opacity: 0.8))
                    .rotationEffect(Angle(degrees: 45))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                
                    HStack {
                        Text("It's Corona Time")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    
                        Spacer()
                    }.padding(.horizontal, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.searching.toggle()
                        
                        if self.music {
                            if self.searching {
                                playSound(sound: "its-corona-time", type: "mp3")
                            } else {
                                playSound(sound: "Silence", type: "mp3")
                            }
                        }
                        
                        if ((self.detector.lastDistance == .near) || (self.detector.lastDistance == .immediate))
                        {
                         print("Test")
                        //prompts the notification
                                let content = UNMutableNotificationContent()
                                content.title = "Oops I'm too close"
                                content.body = "Get away from him now! Doyou wabt to die or something?"
                                content.sound = .default
                                
                                let request = UNNotificationRequest(identifier: "Close", content: content, trigger: nil)
                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                
                                iBeaconNear = true
                        }
                        else {
                            iBeaconNear = false
                        }
                        
                        if ((self.numbers == self.major) && (self.major == self.minor)) {
                            self.UUIDReady = false
                        } else if ( self.numbers != "" ) {
                            self.UUIDReady = true
                        }
                        
                        }) {
                            if !searching {
                                HStack {
                                    Text("Start Searching")
                                    Image(systemName: "dot.radiowaves.left.and.right")
                                }
                                .font(.title)
                                .foregroundColor(Color.black)
                                .padding(.all, 30)
                                .padding(.vertical, 100)
                                .background(Color.green)
                                .cornerRadius(150)
                                .shadow(radius: 30)
                            } else {
                                HStack {
                                    Text("Stop Searching")
                                    Image(systemName: "dot.radiowaves.left.and.right")
                                }
                                .font(.title)
                                .foregroundColor(Color.black)
                                .padding(.all, 30)
                                .padding(.vertical, 100)
                                .background(Color.red)
                                .cornerRadius(150)
                                .shadow(radius: 30)
                            }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
							Button(action: {
								self.isShowingAlert = true
								
							}) {
                                      Text("Notification Test")
                                        .font(.headline)
                                        .padding(.all, 20)
                                        .foregroundColor(.black)
                                        .background(Color.gray)
                                        .cornerRadius(20)
                                    }
									.alert(isPresented: $isShowingAlert) {
										Alert(title: Text("Oops too close"), mesage: Text("Get away from him! Are you trying to get sick?"), dismissButton: .deafult(Text("Got it!")))
									
									
									}.padding(.all, 10)
                                }
                    
                    /*
                    if(iBeaconNear == true) {
                        let content = UNMutableNotificationContent()
                        content.title = "Oops I'm too close"
                        content.body = "Get away from him now! Doyou wabt to die or something?"
                        content.sound = .default
                        
                        let request = UNNotificationRequest(identifier: "Close", content: content, trigger: nil)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        
                        iBeaconNear = false
                    }
                    else if(iBeaconNear == false) {
                        iBeaconNear = true
                    }
                    */
                    
                    
                }
                
            }  //First Tab Section
                .tabItem {
                    VStack {
                        Image(systemName: "person.3.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            
            //Second Page Section
            
            ZStack {
                
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255, opacity: 1.0))
                
                VStack {
                    
                    HStack {
                        
                        Text("COVID-19 News")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            //todo
                        }) {
                            HStack {
                                Text("Refresh")
                                Image(systemName: "arrow.2.squarepath")
                            }
                            .font(.body)
                            .padding(.all, 15)
                            .foregroundColor(.black)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        }
                        
                    }.padding(.horizontal, 10)
                   Spacer()
                }
                
            }
                
                //Second Tab Section
                .tabItem {
                    VStack {
                        Image(systemName: "staroflife")
                        Text("News")
                    }
                }
                .tag(1)
        
                //Third Page Section
            ZStack {
                
                Rectangle()
                    .foregroundColor(.black)
                    .edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255, opacity: 0.8))
                    .rotationEffect(Angle(degrees: 45))
                    .edgesIgnoringSafeArea(.all)
            
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        Text("Your UUID: \(numbers)")
                            .font(.title)
                            .foregroundColor(.gray)
                            .bold()
                        Spacer()
                    }.padding(.horizontal, 10)
                    
                    HStack {
                        Text("Your Major: \(major)")
                            .font(.title)
                            .foregroundColor(.gray)
                            .bold()
                        Spacer()
                    }.padding(.horizontal, 10)
                    
                    HStack {
                        Text("Your Minor: \(minor)")
                            .font(.title)
                            .foregroundColor(.gray)
                            .bold()
                        Spacer()
                    }.padding(.horizontal, 10)
                    
                    Spacer()
                    
                    Toggle(isOn: $music) {
                        Text("Corona Music")
                            .bold()
                    }
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(30)
                    
                    Spacer()
                    
                }
    
            }
                //Third Tab Section
                .tabItem {
                    VStack {
                        Image(systemName: "lock.shield")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
