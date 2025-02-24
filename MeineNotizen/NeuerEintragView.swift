//
//  NeuerEintragView.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//
import SwiftUI

struct NeuerEintragView: View {
    @ObservedObject var viewModel: MerklistenViewModel
    @State private var titel: String = ""
    @State private var notiz: String = ""
    @State private var gewählteKategorie: Kategorie = .sonstiges
    @Environment(\.presentationMode) var presentationMode
    @State private var showSavedMessage = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Button("Abbrechen") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                    .font(.headline)
                    
                    Spacer()
                    
                    Text("Neue Notiz")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Spacer().frame(width: 80)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                HStack {
                    Text("Kategorie:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Menu {
                        ForEach(Kategorie.allCases, id: \.self) { kategorie in
                            Button(action: { self.gewählteKategorie = kategorie }) {
                                Label(kategorie.rawValue, systemImage: iconForCategory(kategorie))
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: iconForCategory(gewählteKategorie))
                                .foregroundColor(.blue)
                            Text(gewählteKategorie.rawValue)
                                .fontWeight(.bold)
                        }
                        .padding(10)
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .animation(.easeInOut(duration: 0.2), value: gewählteKategorie)
                    }
                }
                .padding(.horizontal)
                
                // Titelfeld in einer Card
                VStack(alignment: .leading, spacing: 6) {
                    Text("Titel")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    TextField("Gib einen Titel ein", text: $titel)
                        .padding()
                        .background(Theme.cardColor)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notiz")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    TextEditor(text: $notiz)
                        .padding(8)
                        .frame(height: 150)
                        .background(Theme.cardColor)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                }
                
                Button(action: speichernNeueNotiz) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .opacity(showSavedMessage ? 1 : 0)
                        Text("Hinzufügen")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                    .padding(.horizontal)
                }
                .disabled(titel.isEmpty || notiz.isEmpty)
                
                Spacer()
            }
            .padding()
            
            // Toast-Popup
            if showSavedMessage {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Gespeichert!")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func speichernNeueNotiz() {
        viewModel.hinzufuegen(titel: titel, notiz: notiz, kategorie: gewählteKategorie)
        withAnimation {
            showSavedMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showSavedMessage = false
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func iconForCategory(_ category: Kategorie) -> String {
        switch category {
        case .privat: return "lock.fill"
        case .arbeit: return "briefcase.fill"
        case .einkauf: return "cart.fill"
        case .idee: return "lightbulb.fill"
        case .sonstiges: return "tag.fill"
        }
    }
}
