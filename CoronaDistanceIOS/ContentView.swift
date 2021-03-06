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
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import Foundation


//var locationManager: CLLocationManager!
var iBeaconNear = false
   

/*
 MAYBE CHANGE
 var didChange = PassthroughSubject<Void, Never>() to var didChange = ObservablePublisher()
 */


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
struct dataType : Identifiable {
    var id : String
    var title : String
    var desc : String
    var url : String
    var image : String
}

class GetData : ObservableObject {
    @Published var datas = [dataType]()
    
    init() {
        let source = "https://newsapi.org/v2/top-headlines?q=covid&apiKey=a7e759e71fa0436b89b9d4c353a8f1f0"
        
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let img = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, title: title, desc: description, url: url, image: img))
                }
                
                
                
            }
        }.resume()
    }
}

struct webView : UIViewRepresentable {
    
    var url : String
    func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView {
        
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webView>) {
        
    }
}



 



struct ContentView: View {
    
    @State private var selection = 0
    @State private var searching = false
    @ObservedObject var detector = BeaconDetector()
    @State var music: Bool = true
    @State private var isShowingAlert = false
	@State private var isShowingAlert2 = false
    @ObservedObject var list = GetData()

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
                    //Button to stop or start corona music
                    Button(action: {
                        
                        self.searching.toggle()
                        
                        if self.music {
                            if self.searching {
                                playSound(sound: "its-corona-time", type: "mp3")
                            } else {
                                playSound(sound: "Silence", type: "mp3")
                            }
                        }
                        //Checks if distance of beacon is near or immediate
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
                        
                        Button(action: {
                            self.isShowingAlert2 = true
                            
                        }) {
                                  Text("Get Information")
                                    .font(.headline)
                                    .padding(.all, 20)
                                    .foregroundColor(.black)
                                    .background(Color.gray)
                                    .cornerRadius(20)
                        }
						.alert(isPresented: $isShowingAlert2) {
								Alert(title: Text("Info"), message: Text("This was was created to help practice social distancing and to promote social awareness during the CoronaVirus Pandemic. Press the Button to start practicing Social Distancing today!(If you wish to turn off the music go to the Settings tab and switch music off)"), dismissButton: .default(Text("Got it!")))
									
									
						}.padding(.all, 10)
                    //alert stuff
                                
                            Spacer()
                        
							//Test Button for notification when two beacons are too close
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
										Alert(title: Text("Oops too close"), message: Text("Get away from him! Are you trying to get sick?"), dismissButton: .default(Text("Got it!")))
									
									
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
                    //View for New articles
                    NavigationView{
                    
                    List(list.datas){i in
                        
                        NavigationLink(destination: webView(url: i.url).navigationBarTitle("", displayMode: .inline)) {
                            
                            HStack(spacing: 15) {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(i.title).fontWeight(.heavy)
                                    Text(i.desc).lineLimit(2)
                                }
                                
                                if i.image != "" {
                                    WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                                    .resizable()
                                    .frame(width: 110, height: 135)
                                    //.cornerRadius(20)
                                }

                            }.padding(.vertical, 15)
                        }
                        
                        
                    }.navigationBarTitle("COVID-19 News")
                    }
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
                    
                    
                    Text("Your UUID:")
                        .font(.title)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Text("35F9689E-21AF-444D-A700-B15f0C136804")
                        .font(.body)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Spacer()
                    
                    
                    Text("Your Major: 12300")
                        .font(.title)
                        .foregroundColor(.gray)
                        .bold()
                       
                    
                    Spacer()
                    
                    Text("Your Minor: 45600")
                        .font(.title)
                        .foregroundColor(.gray)
                        .bold()
                        
                    
                    
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
