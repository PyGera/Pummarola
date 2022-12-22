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
    
    @State var flagFirstTime: Bool
    @State var flagRunning: Bool
    @State var flagPaused: Bool
    
    @State var currentTimer: Int
    @State var todayIndex: Int
    
    
    @State private var showingAlert = false
    @State var subjectSelector: Int
    @State var center: UNUserNotificationCenter
    @State var queue: DispatchQueue
    @State var secondPassed: Double
    @State var timer: DispatchSourceTimer?
    
    @State var secondsStudySession: Int
    @State var secondsRelaxSession: Int
    @State var sessions: Int
    
    
    init() {
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
        self.queue = DispatchQueue(label: "group.com.federicogerardi.Pummarola")
        self.secondPassed = 0.0
        self.timer = nil
        self.secondsStudySession = 0
        self.secondsRelaxSession = 0
        self.sessions = 0
    }
    
    func startTimer() {
        
        sessions = 0
        
        if (subjectSelector == -1) {
            Alert(title: Text("Create a Subject First!"), message: Text("Subjects >> Add Subject"), dismissButton: .default(Text("Ok")))
        }
        
        currentTimer = 0
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // handle the user's response
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
        
        var startTime = Date()
        var endTime = Calendar.current.date(byAdding: .minute, value: Int(currentTimer == 1 ? Double(modelData.subjects[subjectSelector].relax) : Double(modelData.subjects[subjectSelector].study)),to: Date())!
        
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(1))
        
        
        timer!.setEventHandler {
            if (timeArray[1] < 1) {
                if (currentTimer == 0) {
                    currentTimer = 1
                    let content = UNMutableNotificationContent()
                    content.title = "Go back to study!"
                    content.body = "It's time to work!"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(modelData.subjects[subjectSelector].relax*60), repeats: false)
                    let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
                    center.add(request) { (error) in
                        if let error = error {
                            print("Error scheduling notification: \(error)")
                        }
                    }
                    
                } else {
                    currentTimer = 0
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
                    sessions += 1
                }
                
                
                
                startTime = Date()
                endTime = Calendar.current.date(byAdding: .minute, value: Int(currentTimer == 1 ? Double(modelData.subjects[subjectSelector].relax) : Double(modelData.subjects[subjectSelector].study)),to: Date())!
            }
            
            if (currentTimer == 0) {
                secondsStudySession = (sessions*modelData.subjects[subjectSelector].study*60) + Int(Date().timeIntervalSince(startTime))
            }
            
            else {
                secondsRelaxSession = (sessions*modelData.subjects[subjectSelector].relax*60) + Int(Date().timeIntervalSince(startTime))
            }
            
            timeArray = [Date().timeIntervalSince(startTime), endTime.timeIntervalSince(Date())]
            secondPassed = Date().timeIntervalSince(startTime)
            
            
            print("study: \(secondsStudySession), relax: \(secondsRelaxSession)")
            
        }
        
        
        timer?.resume()
        
        
    }
    
    func stopTimer() {
        flagFirstTime = true
        flagRunning = false
        timer?.cancel()
        center.removePendingNotificationRequests(withIdentifiers: ["timer"])
        
        modelData.subjects[subjectSelector].studyDays[todayIndex].study += secondsStudySession
        modelData.subjects[subjectSelector].studyDays[todayIndex].relax += secondsRelaxSession
        
        uploadSubjects(subjects: modelData.subjects)
        
        print(modelData.subjects[subjectSelector].studyDays[todayIndex].study)
        print(modelData.subjects[subjectSelector].studyDays[todayIndex].relax)
        
        
        
        secondsStudySession = 0
        secondsRelaxSession = 0
    }
    
    var body: some View {
        VStack (alignment: .center) {
            HStack {
                Text("Timer").font(.largeTitle).bold()
                Spacer()
            }
            
            Picker ("Subject", selection: $subjectSelector) {
                if modelData.subjects.isEmpty {
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 0.96, green: 0.44, blue: 0.5))
                        Text("None").font(.headline).bold()
                    } .tag(-1)
                }
                else {
                    ForEach(modelData.subjects) { subject in
                            HStack {
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color(red: subject.color[0], green: subject.color[1], blue: subject.color[2]))
                                Text(subject.name).font(.headline).bold()
                            } .tag(subject.id)
                        
                    }
                }
            } .pickerStyle(.wheel).disabled(flagRunning)
            
                .onChange(of: subjectSelector) { subject in
                    timeArray = [0, Double(modelData.subjects[subject].study*60)]
                    totalTime = modelData.subjects[subject].study*60
                }
            
            
            PieChartView(values: timeArray, currentTimer: currentTimer == 0 ? "Study" : "Relax", colors:  [Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]), Color(red: modelData.subjects[subjectSelector].color[0], green: modelData.subjects[subjectSelector].color[1], blue: modelData.subjects[subjectSelector].color[2]).opacity(0.5)], backgroundColor: Color.black, innerRadiusFraction: 0.95)
                .padding(.leading, 75)
            
            
            HStack {
                if flagRunning {
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
