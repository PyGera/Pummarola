//
//  Subject.swift
//  Pummarola
//
//  Created by Federico Gerardi on 15/12/22.
//

import Foundation
import SwiftUI

struct Subject : Identifiable, Codable {
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
