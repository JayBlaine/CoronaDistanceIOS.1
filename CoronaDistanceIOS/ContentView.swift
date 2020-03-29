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


//var locationManager: CLLocationManager!
var iBeaconNear = false
   
/*********
 MAYBE CHANGE
var didChange = PassthroughSubject<Void, Never>()  to  var didChange  = ObservableObjectPublisher()
and
didChange.send() to self.didChange.send()
 *********/


class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    var didChange = ObservableObjectPublisher()
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
        let uuid = UUID(uuidString: "35f9689e-21af-444d-a700-b15f0c136804")!
        //Replace with either user input or random uuid generator, 5A4BCFCE PLACEHOLDER TODO
        //MAYBE MAKE !USER UUID
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
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
    
    func update(distance: CLProximity) {
        lastDistance = distance
        self.didChange.send()
    }
}


 



struct ContentView: View {
    
    @State private var selection = 1
    @State private var searching = false
    @State var numbers: String = ""
    @State var major: String = ""
    @State var minor: String = ""
    @ObservedObject var detector = BeaconDetector()
    @State var UUIDReady: Bool = false

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
                
                    Text("It's Corona Time")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.searching.toggle()
                        
                        if self.searching {
                            playSound(sound: "its-corona-time", type: "mp3")
                            
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
                        } else {
                            playSound(sound: "Silence", type: "mp3")
                            iBeaconNear = false
                        }
                            
                        if self.searching {
                            if ((self.detector.lastDistance == .near) || (self.detector.lastDistance == .immediate))
                           {	
                           //prompts the notification
                                       let content = UNMutableNotificationContent()
                                       content.title = "Oops I'm too close"
                                       content.body = "Get away from him now! Do you want to die or something?"
                                       content.sound = .default
                                       
                                       let request = UNNotificationRequest(identifier: "Close", content: content, trigger: nil)
                                       UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                       
                                       iBeaconNear = true
                           }
                            else {
                                iBeaconNear = false
                            }
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
                   
                    HStack {
                        VStack {
                            Text("UUID: \(numbers)")
                                .foregroundColor(.white)
                            Text("Major: \(major)")
                                .foregroundColor(.white)
                            Text("Minor: \(minor)")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    //Asks User for UUID
                    Text("A UUID consists of 8 digits/letters - 4 digits/letters - 4 digits/letters - 4 digits/letters - 12 digits/letters (no spaces)")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    HStack {
                        Text("Enter a UUID:")
                        TextField("ex. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", text: $numbers)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(20)
                       
                    //Asks User for Major
                    Text("A Major consists of a digit between 1 - 65,000")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    HStack {
                        Text("Enter a Major:")
                        TextField("ex. xxxxx", text: $major)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(20)
                    
                    //Asks user for Minor
                    Text("A Minor consists of a digit between 1 - 65,000")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    HStack {
                        Text("Enter a Minor:")
                        TextField("ex. xxxxx", text: $minor)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(20)
                    
                    
                    
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
