//
//  CategoryFilterSheet.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//

import SwiftUI

struct CategoryFilterSheet: View {
    @Binding var isShowing: Bool
    @Binding var ausgewählteKategorie: Kategorie?

    // Zwei-spaltiges Grid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            // Dimmed Hintergrund, der per Tap geschlossen werden kann
            if isShowing {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isShowing = false }
                    }
            }
            
            // Bottom Sheet
            VStack(spacing: 20) {
                // Drag-Indicator
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(Color.secondary.opacity(0.5))
                    .padding(.top, 8)
                
                // Titel
                Text("Kategorie auswählen")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                
                Divider()
                    .padding(.horizontal)
                
                // Grid der Kategorien
                LazyVGrid(columns: columns, spacing: 16) {
                    // Option "Alle" – mit eigenem Symbol und Gradient-Hintergrund
                    Button(action: {
                        ausgewählteKategorie = nil
                        withAnimation { isShowing = false }
                    }) {
                        HStack {
                            Image(systemName: "square.grid.2x2.fill")
                            Text("Alle")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    
                    // Buttons für jede Kategorie
                    ForEach(Kategorie.allCases, id: \.self) { kategorie in
                        Button(action: {
                            ausgewählteKategorie = kategorie
                            withAnimation { isShowing = false }
                        }) {
                            HStack {
                                Image(systemName: iconForCategory(kategorie))
                                Text(kategorie.rawValue)
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: backgroundGradient(for: kategorie)),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Schließen & Anwenden Button mit Gradient
                Button(action: {
                    withAnimation { isShowing = false }
                }) {
                    Text("Schließen & Anwenden")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accentColor, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            // Sanfte Transition und Animation beim Ein-/Ausblenden
            .transition(.move(edge: .bottom))
            .offset(y: isShowing ? 0 : UIScreen.main.bounds.height)
            .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), value: isShowing)
        }
    }
    
    // Gibt das passende Symbol für jede Kategorie zurück
    private func iconForCategory(_ category: Kategorie) -> String {
        switch category {
        case .privat: return "lock.fill"
        case .arbeit: return "briefcase.fill"
        case .einkauf: return "cart.fill"
        case .idee: return "lightbulb.fill"
        case .sonstiges: return "tag.fill"
        }
    }
    
    // Liefert den Farbverlauf für jede Kategorie
    private func backgroundGradient(for category: Kategorie) -> [Color] {
        switch category {
        case .privat:
            return [Color.pink.opacity(0.3), Color.pink.opacity(0.1)]
        case .arbeit:
            return [Color.orange.opacity(0.3), Color.orange.opacity(0.1)]
        case .einkauf:
            return [Color.green.opacity(0.3), Color.green.opacity(0.1)]
        case .idee:
            return [Color.yellow.opacity(0.3), Color.yellow.opacity(0.1)]
        case .sonstiges:
            return [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]
        }
    }
}
