//
//  MerklistenEintrag.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//

import Foundation

enum Kategorie: String, CaseIterable, Codable, Identifiable {
    case privat = "Privat"
    case arbeit = "Arbeit"
    case einkauf = "Einkauf"
    case idee = "Idee"
    case sonstiges = "Sonstiges"
    
    var id: String { self.rawValue }
}


struct MerklistenEintrag: Identifiable, Codable {
    var id: UUID = UUID()
    var titel: String
    var notiz: String
    var erstelltAm: Date = Date()
    var kategorie: Kategorie
}
