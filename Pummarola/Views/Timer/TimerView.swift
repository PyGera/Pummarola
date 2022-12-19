//
//  TimerView.swift
//  Pummarola
//
//  Created by Federico Gerardi on 13/12/22.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    @EnvironmentObject var modelData: ModelData
    @State var totalTime: Int
    @State var timeArray: [Double]
    
    @State var timer: Timer?// DispatchSourceTimer? // Timer?
    @State var flagFirstTime: Bool
    @State var flagRunning: Bool
    @State var flagPaused: Bool
    
    @State var currentTimer: Int
    @State var todayIndex: Int
    
    @State private var showingAlert = false
    @State var subjectSelector: Int
    @State var center: UNUserNotificationCenter
    

    
    init() {
        self.timer = nil
        self.flagFirstTime = true
        self.flagRunning = false
        self.flagPaused = false
        self.showingAlert = false
        self.subjectSelector = 0
        self.totalTime = 25*60
        self.timeArray = [0,Double(25*60)]
        self.currentTimer = 0
        self.todayIndex = 0
        self.center = UNUserNotificationCenter.current()
        
        UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")?.set(timeArray, forKey: "timeArray")
    }
    
    func startTimer() {
        
        
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // handle the user's response
        }
        
        
        
        
        if (flagPaused) {
            flagPaused = false
        }
        
        if (flagFirstTime) {
            timeArray = [0, Double(totalTime)]
            flagFirstTime = false
            flagRunning = true
        }
        
        if (modelData.subjects[subjectSelector].studyDays.count == 0) {
            modelData.subjects[subjectSelector].studyDays.append(StudyDay(today: Date(), study: 0, relax: 0))
            todayIndex = 0
        }
        else if (Calendar.current.startOfDay(for: modelData.subjects[subjectSelector].studyDays[modelData.subjects[subjectSelector].studyDays.count-1].today) == Calendar.current.startOfDay(for: Date())) {
            todayIndex = modelData.subjects[subjectSelector].studyDays.count-1
        }
        else {
            modelData.subjects[subjectSelector].studyDays.append(StudyDay(today: Date(), study: 0, relax: 0))
            todayIndex = modelData.subjects[subjectSelector].studyDays.count-1
        }
        
        print(subjectSelector)
        print(todayIndex)
        
        let content = UNMutableNotificationContent()
        content.title = "It'relax time"
        content.body = "Have a coffee or sleep for a while"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(modelData.subjects[subjectSelector].study*60), repeats: false)
        let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
        center.add(request) { (error) in
           if let error = error {
               print("Error scheduling notification: \(error)")
           }
        }
        
//        let queue = DispatchQueue(label: "group.com.federicogerardi.Pummarola", qos: .background)
//
//        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
//
//        timer!.schedule(deadline: .now(), repeating: .seconds(1))
//
//        timer!.setEventHandler {
//
//        }
//
//        timer!.resume()
    
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if (timeArray[1] < 2) {
                let content = UNMutableNotificationContent()

                if (currentTimer == 0) {
                    content.title = "Go back to study"
                    content.body = "It's time to go back to work"
                    timeArray = [0, Double(modelData.subjects[subjectSelector].relax*60)]
                    totalTime = modelData.subjects[subjectSelector].relax*60
                    currentTimer = 1
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(totalTime), repeats: false)
                    let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)

                    center.add(request) { (error) in
                       if let error = error {
                           print("Error scheduling notification: \(error)")
                       }
                    }


                }
                else {
                    content.title = "It'relax time"
                    content.body = "Take a coffee or sleep for a while"
                    timeArray = [0, Double(modelData.subjects[subjectSelector].study*60)]
                    totalTime = modelData.subjects[subjectSelector].study*60
                    currentTimer = 0
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(totalTime), repeats: false)
                    let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)

                    center.add(request) { (error) in
                       if let error = error {
                           print("Error scheduling notification: \(error)")
                       }
                   }
                }

                 uploadSubjects(subjects: modelData.subjects)
            }

            if (currentTimer == 0) {
                modelData.subjects[subjectSelector].studyDays[todayIndex].study += 1

            }
            else {
                modelData.subjects[subjectSelector].studyDays[todayIndex].relax += 1
            }
            
            let coso0 : [Double] = UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")?.object(forKey: "timeArray") as! [Double]
            let coso : [Double] = [coso0[0] + 1.0,  coso0[1] - 1.0]
            
            UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")!.set(coso, forKey: "timeArray")
            timeArray = UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")!.object(forKey: "timeArray") as! [Double]

                print(timeArray)

            })
        
        
        
//        queue.async {
//            var i = 0
//            while(flagRunning) {
//                print(i)
//                i+=1
//            }
//        }
        
        
        
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
                } .tag(0)
                
                ForEach(modelData.subjects) { subject in
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(red: subject.color[0], green: subject.color[1], blue: subject.color[2]))
                            Text(subject.name).font(.headline).bold()
                        } .tag(subject.id)
                    
                }
            } .pickerStyle(.wheel).disabled(flagRunning)
            
                .onChange(of: subjectSelector) { subject in
                    timeArray = [0, Double(modelData.subjects[subject].study*60)]
                    totalTime = modelData.subjects[subject].study*60
                    UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")?.set(timeArray, forKey: "timeArray")
                }
            
            
            PieChartView(values: timeArray, currentTimer: currentTimer == 0 ? "Study" : "Relax", colors:  [Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]), Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]).opacity(0.5)], backgroundColor: Color.black, innerRadiusFraction: 0.95)
                .padding(.leading, 75)
            
            
            HStack {
                if flagRunning {
                    if flagPaused {
                        Button(action: startTimer) {
                            Image(systemName: "play.fill")
                        }
                        .padding()
                            .background(Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    
                    
                    else {
                        Button(action: pauseTimer) {
                            Image(systemName: "pause.fill")

                        }
                        .padding()
                            .background(Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                    
                    
                    
                    Button(action: stopTimer) {
                        Image(systemName: "stop.fill")

                    }
                    .padding()
                        .background(Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
                else {
                    Button(action: startTimer) {
                        Image(systemName: "play.fill")
                    }
                    .padding()
                        .background(Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]))
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
