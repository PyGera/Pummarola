//
//  TimerView.swift
//  Pummarola
//
//  Created by Federico Gerardi on 13/12/22.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var modelData: ModelData
    @State var totalTime: Int
    @State var timeArray: [Double]
    
    @State var timer: Timer?
    @State var flagFirstTime: Bool
    @State var flagRunning: Bool
    @State var flagPaused: Bool
    
    @State private var showingAlert = false
    @State var subjectSelector: Subject 

    
    init() {
        self.timer = nil
        self.flagFirstTime = true
        self.flagRunning = false
        self.flagPaused = false
        self.showingAlert = false
        self.subjectSelector = Subject(id: 100, name: "None", color: [0.96, 0.44, 0.5], studyDays: [], study: 25, relax: 5, total: 4, longRelax: 30)
        self.totalTime = 25*60
        self.timeArray = [0,Double(25*60)]
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
            HStack {
                Text("Timer").font(.largeTitle).bold()
                Spacer()
            }
            
            Picker ("Subject", selection: $subjectSelector) {
                HStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(red: 0.96, green: 0.44, blue: 0.5))
                    Text("None").font(.headline).bold()
                } .tag(Subject(id: 100, name: "None", color: [0.96, 0.44, 0.5], studyDays: [], study: 25, relax: 5, total: 4, longRelax: 30))
                
                ForEach(modelData.subjects) { subject in
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(red: subject.color[0], green: subject.color[1], blue: subject.color[2]))
                            Text(subject.name).font(.headline).bold()
                        } .tag(subject)
                    
                }
            } .pickerStyle(.wheel)
            
                .onChange(of: subjectSelector) { subject in
                    timeArray = [0, Double(subject.study*60)]
                    totalTime = subject.study*60
                }
            
            
            PieChartView(values: timeArray, colors:  [Color(red: subjectSelector.color[0], green: subjectSelector.color[1], blue: subjectSelector.color[2]), Color(red: subjectSelector.color[0], green: subjectSelector.color[1], blue: subjectSelector.color[2]).opacity(0.5)], backgroundColor: Color.black, innerRadiusFraction: 0.95)
                .padding(.leading, 75)
            
            
            HStack {
                if flagRunning {
                    if flagPaused {
                        Button(action: startTimer) {
                            Image(systemName: "play.fill")
                        }
                        .padding()
                            .background(Color(red: subjectSelector.color[0], green: subjectSelector.color[1], blue: subjectSelector.color[2]))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    
                    
                    else {
                        Button(action: pauseTimer) {
                            Image(systemName: "pause.fill")

                        }
                        .padding()
                            .background(Color(red: subjectSelector.color[0], green: subjectSelector.color[1], blue: subjectSelector.color[2]))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    
                    
                    
                    Button(action: stopTimer) {
                        Image(systemName: "stop.fill")

                    }
                    .padding()
                        .background(Color(red: subjectSelector.color[0], green: subjectSelector.color[1], blue: subjectSelector.color[2]))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
                else {
                    Button(action: startTimer) {
                        Image(systemName: "play.fill")
                    }
                    .padding()
                        .background(Color(red: subjectSelector.color[0], green: subjectSelector.color[1], blue: subjectSelector.color[2]))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
            }
            .padding()
            
            Spacer()
                
            
        }.padding()
        
            
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .environmentObject(ModelData())
    }
}
