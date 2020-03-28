//
//  ContentView.swift
//  CoronaDistanceIOS
//
//  Created by Jarrod Ragsdale on 3/28/20.
//  Copyright © 2020 Group. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @State private var searching = false
 
    var body: some View {
        TabView(selection: $selection){
            VStack {
            
                Text("It's Corona Time")
                    .font(.title)
                    .padding(.top)
                
                Spacer()
                
                Button(action: {
                    //todo
                    }) {
                     
                        HStack {
                            Text("Start Searching ")
                            Image(systemName: "dot.radiowaves.left.and.right")
                        }
                        .foregroundColor(Color.black)
                        .padding(.all, 30)
                        .background(Color.green)
                        .cornerRadius(30)
                }
                
                Spacer()
                
                
                
                
            }
                
                .tabItem {
                    VStack {
                        Image(systemName: "person.3.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            Text("Second Views")
                .font(.title)
                
                
                
                
                .tabItem {
                    VStack {
                        Image(systemName: "staroflife")
                        Text("News")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
