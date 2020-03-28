//
//  ContentView.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 2
    @State private var searching = false
    @State var numbers: String = ""
    @State var major: String = ""
    @State var minor: String = ""
 
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
            
            Text("News Incoming")
                .font(.title)
                
                
                
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
                    
                    
                    
                        Text("UUID: \(numbers)")
                            .foregroundColor(.white)
                        Text("Major: \(major)")
                            .foregroundColor(.white)
                        Text("Minor: \(minor)")
                            .foregroundColor(.white)
                    
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
                    }
                    .padding()
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(20)
                       
                    //Asks User for Major
                    Text("Enter a digit between 1 - 65,000")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    HStack {
                        Text("Enter a Major:")
                        TextField("ex. xxxxx", text: $major)
                    }
                    .padding()
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(20)
                    
                    //Asks user for Minor
                    Text("Enter a digit between 1 - 65,000")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    HStack {
                        Text("Enter a Minor:")
                        TextField("ex. xxxxx", text: $minor)
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
