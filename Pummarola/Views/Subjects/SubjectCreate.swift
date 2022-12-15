//
//  SubjectCreate.swift
//  Pummarola
//
//  Created by Federico Gerardi on 15/12/22.
//

import SwiftUI
import ColorKit

struct SubjectCreate: View {
    @EnvironmentObject var modelData: ModelData
    
    @State var name: String = ""
    @State var study: String = ""
    @State var relax: String = ""
    @State var longRelax: String = ""
    @State var sessions: String = ""
    @State var selectedColor: Color = Color(red: 0, green: 0, blue: 0)
    
    func addSubject() {
        print(selectedColor)
        
        modelData.subjects.append(Subject(id: modelData.subjects.count, name: name, color: [Double(UIColor(selectedColor).red), Double(UIColor(selectedColor).green), Double(UIColor(selectedColor).blue)], studyDays: [], study: Int(study)!, relax: Int(relax)!, total: Int(sessions)!, longRelax: Int(longRelax)!))
        
        uploadSubjects(subjects: modelData.subjects)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            TextField("Subject name",text: $name)
                .font(.largeTitle)
                .bold()
            
            List {
                TextField("Minutes of study", text: $study)
                    .keyboardType(.numberPad)
                    .bold()
                
                TextField("Minutes of relax", text: $relax)
                    .keyboardType(.numberPad)
                    .bold()
                
                TextField("Minutes of long relax", text: $longRelax)
                    .keyboardType(.numberPad)
                    .bold()
                
                TextField("Number of session", text: $sessions)
                    .keyboardType(.numberPad)
                    .bold()
                
                VStack (alignment: .leading) {
                    Text("Color").bold()
                    Picker("Color", selection: $selectedColor) {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 0.96, green: 0.44, blue: 0.5))
                            .tag(Color(red: 0.96, green: 0.44, blue: 0.5))
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.green)
                            .tag(Color.green)
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.blue)
                            .tag(Color.blue)
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.yellow)
                            .tag(Color.yellow)
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.pink)
                            .tag(Color.pink)
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.orange)
                            .tag(Color.orange)
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.purple)
                            .tag(Color.purple)
                    }
                        .pickerStyle(.wheel)
                }
                
            
                Button(action: addSubject) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Subject")
                    }
                    
                }
                .foregroundColor(Color(red: 0.96, green: 0.44, blue: 0.5))
                        
                
                
                
            }
            
            
            
            
            
            
        }.padding()
    }
}

struct SubjectCreate_Previews: PreviewProvider {
    static var previews: some View {
        SubjectCreate()
            .environmentObject(ModelData())
    }
}
