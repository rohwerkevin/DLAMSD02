//
//  MerklistenViewModel.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//
import SwiftUI

enum SortierModus {
    case titel
    case datum
}

class MerklistenViewModel: ObservableObject {
    @Published var eintraege: [MerklistenEintrag] = [] {
        didSet { speichern() }
    }

    @Published var sortierModus: SortierModus = .datum {
        didSet { sortiereEintraege() }
    }

    private let speicherKey = "MeineNotizen"

    init() {
        laden()
    }

    // Hinzufügen
    func hinzufuegen(titel: String, notiz: String, kategorie: Kategorie) {
        let neuerEintrag = MerklistenEintrag(titel: titel, notiz: notiz, kategorie: kategorie)
        eintraege.append(neuerEintrag)
        sortiereEintraege()
    }

    // Löschen mit IndexSet ( für List)
    func loeschen(at offsets: IndexSet) {
        eintraege.remove(atOffsets: offsets)
    }

    // Löschen eines einzelnen Eintrags
    func loescheEintrag(_ eintrag: MerklistenEintrag) {
        if let index = eintraege.firstIndex(where: { $0.id == eintrag.id }) {
            eintraege.remove(at: index)
        }
    }

    // Sortierung
    func sortiereEintraege() {
            switch sortierModus {
            case .titel:
                eintraege.sort { $0.titel.lowercased() < $1.titel.lowercased() }
            case .datum:
                eintraege.sort { $0.erstelltAm > $1.erstelltAm }
            }
        }

    // Speicchern & Laden mit UserDefaults
    private func speichern() {
        if let encoded = try? JSONEncoder().encode(eintraege) {
            UserDefaults.standard.set(encoded, forKey: speicherKey)
        }
    }

    private func laden() {
        if let savedData = UserDefaults.standard.data(forKey: speicherKey),
           let decoded = try? JSONDecoder().decode([MerklistenEintrag].self, from: savedData) {
            eintraege = decoded
            sortiereEintraege()
        }
    }
}
