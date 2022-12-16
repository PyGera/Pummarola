//
//  SubjectList.swift
//  Pummarola
//
//  Created by Federico Gerardi on 15/12/22.
//

import SwiftUI

struct SubjectList: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(modelData.subjects) { subject in
                    NavigationLink {
                        SubjectDetails(subject: subject)
                    } label : {
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(red: subject.color[0], green: subject.color[1], blue: subject.color[2]))
                            Text(subject.name).font(.headline).bold()
                        }
                    }
                }
                
                NavigationLink {
                    SubjectCreate()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Subject")
                    }.foregroundColor(Color(red: 0.96, green: 0.44, blue: 0.5))
                }
                
            }
            
            
            .navigationTitle("Subjects")
        }
    }
}

struct SubjectList_Previews: PreviewProvider {
    static var previews: some View {
        SubjectList()
            .environmentObject(ModelData())
    }
}
