//
//  MerklistenEintragDetail.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//

import SwiftUI

struct MerklistenEintragDetail: View {
    @ObservedObject var viewModel: MerklistenViewModel
    @State private var titel: String
    @State private var notiz: String
    @State private var kategorie: Kategorie
    let eintrag: MerklistenEintrag
    @Environment(\.presentationMode) var presentationMode
    @State private var showSavedMessage = false  // Für Speichern-Toast
    @State private var showDeleteMessage = false // Für Löschen-Toast

    init(eintrag: MerklistenEintrag, viewModel: MerklistenViewModel) {
        self.eintrag = eintrag
        self.viewModel = viewModel
        _titel = State(initialValue: eintrag.titel)
        _notiz = State(initialValue: eintrag.notiz)
        _kategorie = State(initialValue: eintrag.kategorie)
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Notiz bearbeiten")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        deleteNote()
                    }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Menu {
                            ForEach(Kategorie.allCases, id: \.self) { kategorie in
                                Button(action: { self.kategorie = kategorie }) {
                                    Text(kategorie.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                Text(kategorie.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Titel")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            TextField("Gib einen Titel ein", text: $titel)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                .padding(.horizontal)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notiz")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            TextEditor(text: $notiz)
                                .padding(8)
                                .frame(height: 180)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                .padding(.horizontal)
                        }

                        HStack {
                            Spacer()
                            Text("Erstellt am: \(eintrag.erstelltAm, style: .date)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .padding(.vertical)
                }

                Button(action: speichernÄnderungen) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .opacity(showSavedMessage ? 1 : 0)
                        Text("Speichern")
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
            .padding(.bottom, 16)

            if showSavedMessage {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Gespeichert!")
                    }
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            if showDeleteMessage {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Notiz gelöscht!")
                    }
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut, value: showSavedMessage)
        .animation(.easeInOut, value: showDeleteMessage)
        .navigationBarBackButtonHidden(true)
    }

    private func speichernÄnderungen() {
        if let index = viewModel.eintraege.firstIndex(where: { $0.id == eintrag.id }) {
            viewModel.eintraege[index].titel = titel
            viewModel.eintraege[index].notiz = notiz
            viewModel.eintraege[index].kategorie = kategorie
        }

        withAnimation {
            showSavedMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSavedMessage = false
            }
        }
    }
    
    private func deleteNote() {
        if let index = viewModel.eintraege.firstIndex(where: { $0.id == eintrag.id }) {
            withAnimation {
                viewModel.eintraege.remove(at: index)
            }
        }
        withAnimation {
            showDeleteMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showDeleteMessage = false
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}
