//
//  SubjectDetails.swift
//  Pummarola
//
//  Created by Federico Gerardi on 15/12/22.
//

import SwiftUI

struct SubjectDetails: View {
    @EnvironmentObject var modelData: ModelData
    @State var subject: Subject
    
    func deleteSubject() {
        modelData.subjects.remove(at: subject.id)
        
        if (modelData.subjects.count>0) {
            for i in 0...(modelData.subjects.count-1) {
                if (modelData.subjects[i].id != i) {
                    modelData.subjects[i].id = i
                }
            }
        }
        
        uploadSubjects(subjects: modelData.subjects)
    }
    
    var body: some View {
        
        VStack (alignment: .leading) {
            Text(subject.name)
                .font(.largeTitle)
                .bold()
            
            List {
                
                HStack {
                    Text("Study hours today").font(.headline)
                    Spacer()
                    Text(
                        subject.studyDays.count == 0 ? "0 seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.study) : 0 }) / 60.0) < 1 ? "\((subject.studyDays.reduce(into: 0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? d.study : 0 })) seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.study) : 0 }) / 3600.0) < 1 ? String(format: "%.2f minutes", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.study) : 0 }) / 60.0)) :
                            String(format: "%.2f hours", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.study) : 0 }) / 3600.0))
                            
                    ).font(.headline).foregroundColor(.accentColor)
                }
                
                HStack {
                    Text("Relax hours today").font(.headline)
                    Spacer()
                    Text(
                        subject.studyDays.count == 0 ? "0 seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.relax) : 0 }) / 60.0) < 1 ? "\((subject.studyDays.reduce(into: 0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? d.relax : 0 })) seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.relax) : 0 }) / 3600.0) < 1 ? String(format: "%.2f minutes", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.relax) : 0 }) / 60.0)) :
                            String(format: "%.2f hours", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Calendar.current.startOfDay(for: d.today) == Calendar.current.startOfDay(for: Date()) ? Double(d.relax) : 0 }) / 3600.0))
                            
                    ).font(.headline).foregroundColor(.accentColor)
                }
                
                HStack {
                    Text("Total study hours").font(.headline)
                    Spacer()
                    Text(
                        subject.studyDays.count == 0 ? "0 seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.study) }) / 60.0) < 1 ? "\((subject.studyDays.reduce(into: 0) { (r,d) in r += d.study })) seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.study) }) / 3600.0) < 1 ? String(format: "%.2f minutes", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.study) }) / 60.0)) :
                            String(format: "%.2f hours", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.study) }) / 3600.0))
                            
                    ).font(.headline).foregroundColor(.accentColor)
                }
                
                HStack {
                    Text("Total relax hours").font(.headline)
                    Spacer()
                    Text(
                        subject.studyDays.count == 0 ? "0 seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.relax) }) / 60.0) < 1 ? "\((subject.studyDays.reduce(into: 0) { (r,d) in r += d.relax })) seconds" :
                            ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.relax) }) / 3600.0) < 1 ? String(format: "%.2f minutes", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.relax) }) / 60.0)) :
                            String(format: "%.2f hours", ((subject.studyDays.reduce(into: 0.0) { (r,d) in r += Double(d.relax) }) / 3600.0))
                            
                    ).font(.headline).foregroundColor(.accentColor)
                }
                
                Button(action: deleteSubject) {
                    HStack {
                        Image(systemName: "delete.left.fill")
                        Text("Delete Subject").font(.headline)
                    }
                    
                }
                .foregroundColor(Color.red)
                
                
            }
            
            Spacer()
            
            
            
        }
        .padding()
        .tint(Color(red: subject.color[0], green: subject.color[1], blue: subject.color[2]))
        
    }
}

struct SubjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        SubjectDetails(subject: ModelData().subjects[0])
            .environmentObject(ModelData())
    }
}
