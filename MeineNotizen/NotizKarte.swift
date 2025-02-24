//
//  NotizKarte.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//

import SwiftUI

struct NotizKarte: View {
    let eintrag: MerklistenEintrag

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eintrag.titel)
                .font(.headline)
                .foregroundColor(Theme.textColor)

            Text(eintrag.notiz)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)

            HStack {
                Text(eintrag.kategorie.rawValue)
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(5)

                Spacer()

                Text(eintrag.erstelltAm, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Theme.cardColor)
        .cornerRadius(12)
        .shadow(radius: 3, x: 2, y: 2)
    }
}
