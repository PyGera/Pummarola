//
//  TimerView.swift
//  Pummarola
//
//  Created by Federico Gerardi on 13/12/22.
//

import SwiftUI

struct TimerView: View {
    
    @State var totalTime: Int
    @State var timeArray: [Double]
    
    @State var timer: Timer?
    @State var flagFirstTime: Bool
    @State var flagRunning: Bool
    @State var flagPaused: Bool
    
    @State private var showingAlert = false

    
    init(totalTime: Int, timeArray: [Double]) {
        self.totalTime = totalTime
        self.timeArray = timeArray
        self.timer = nil
        self.flagFirstTime = true
        self.flagRunning = false
        self.flagPaused = false
    }
    
    func startTimer() {
        if (flagPaused) {
            flagPaused = false
        }
        
        if (flagFirstTime) {
            timeArray = [0, Double(totalTime)]
            flagFirstTime = false
            flagRunning = true
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
            if (timeArray[1] < 2) {
                flagFirstTime = true
                flagRunning = false
                timer?.invalidate()
            }
            
                timeArray[0] += 1
                timeArray[1] -= 1
            })
        
        
        
    }
    
    func stopTimer() {
        flagFirstTime = true
        flagRunning = false
        timer?.invalidate()
        
    }
    
    func pauseTimer() {
        flagPaused = true
        timer?.invalidate()
        
    }
    
    
    
    
    var body: some View {
        VStack (alignment: .center) {
            
            
            PieChartView(values: timeArray, colors: [Color(red: 0.96, green: 0.44, blue: 0.5), Color.black], backgroundColor: Color.black, innerRadiusFraction: 0.95)
                .padding(.leading, 75)
            
            
            HStack {
                if flagRunning {
                    if flagPaused {
                        Button(action: startTimer) {
                            Image(systemName: "play.fill")
                        }
                        .padding()
                            .background(Color(red: 0.96, green: 0.44, blue: 0.5))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    
                    
                    else {
                        Button(action: pauseTimer) {
                            Image(systemName: "pause.fill")

                        }
                        .padding()
                            .background(Color(red: 0.96, green: 0.44, blue: 0.5))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    
                    
                    
                    Button(action: stopTimer) {
                        Image(systemName: "stop.fill")

                    }
                    .padding()
                        .background(Color(red: 0.96, green: 0.44, blue: 0.5))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
                else {
                    Button(action: startTimer) {
                        Image(systemName: "play.fill")
                    }
                    .padding()
                        .background(Color(red: 0.96, green: 0.44, blue: 0.5))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
            }
            
            Spacer()
                
            
        }
        
            
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(totalTime: 5, timeArray: [0,5])
    }
}
