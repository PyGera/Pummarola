//
//  ContentView.swift
//  Pummarola
//
//  Created by Federico Gerardi on 13/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .timer
    
    enum Tab {
        case timer
        case subjects
    }
    
    
    var body: some View {
        
        TabView(selection: $selection) {
            TimerView(totalTime: 1500, timeArray: [0,1500])
                .tabItem {
                    Label("Timer", systemImage: "clock.fill")
                } .tag(Tab.timer)
            
            SubjectList()
                .tabItem {
                    Label("Subjects", systemImage: "backpack")
                } .tag(Tab.subjects)
        } .tint(Color(red: 0.96, green: 0.44, blue: 0.5))
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
