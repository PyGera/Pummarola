//
//  ModelData.swift
//  Pummarola
//
//  Created by Federico Gerardi on 15/12/22.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var subjects: [Subject] = loadSubjects()
}

func loadSubjects() -> [Subject] {
    
    if (UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")!.string(forKey: "subjects") == nil) {
        uploadSubjects(subjects: [])
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([Subject].self, from: UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")!.string(forKey: "subjects")!.data(using: .utf8)!)
    } catch {
        return [Subject]()
    }
    
}

func uploadSubjects(subjects: [Subject]) {
    
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(subjects)
        
        UserDefaults(suiteName: "group.com.federicogerardi.Pummarola")!.set(String(data: data, encoding: .utf8), forKey: "subjects")
    } catch {
        fatalError("Press F My Friend")
    }
}
