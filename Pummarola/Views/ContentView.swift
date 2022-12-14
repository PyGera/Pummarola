//
//  ContentView.swift
//  Pummarola
//
//  Created by Federico Gerardi on 13/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimerView(totalTime: 5, timeArray: [0,5])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
