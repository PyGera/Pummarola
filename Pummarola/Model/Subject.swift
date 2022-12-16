//
//  Subject.swift
//  Pummarola
//
//  Created by Federico Gerardi on 15/12/22.
//

import Foundation
import SwiftUI

struct Subject : Identifiable, Codable, Hashable {
    static func == (lhs: Subject, rhs: Subject) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.color == rhs.color && lhs.study == rhs.study && lhs.relax == rhs.relax && lhs.total == rhs.total && lhs.longRelax == rhs.longRelax
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(color)
        hasher.combine(study)
        hasher.combine(relax)
        hasher.combine(total)
        hasher.combine(longRelax)
    }
    
    var id: Int
    var name: String
    var color: [Double]
    var studyDays: [StudyDay]
    var study: Int      // In minutes
    var relax: Int      // In minutes
    var total: Int
    var longRelax: Int  // In minutes
}

struct StudyDay : Codable {
    var today: Date
    var study: Int      // In seconds
    var relax: Int      // In seconds
}
