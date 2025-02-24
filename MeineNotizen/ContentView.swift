//
//  ContentView.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MerklistenViewModel()
    @State private var isShowingNewNoteSheet = false
    @State private var isShowingFilterSheet = false
    @State private var isShowingCategorySheet = false
    @State private var isMenuOpen = false
    @State private var sortierModus: SortierModus = .datum
    @State private var ausgewählteKategorie: Kategorie? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    let gefilterteEintraege = viewModel.eintraege.filter {
                        ausgewählteKategorie == nil || $0.kategorie == ausgewählteKategorie
                    }
                    
                    if viewModel.eintraege.isEmpty {
                        // Keine Notizen
                        VStack(spacing: 8) {
                            Image(systemName: "note.text")
                                .font(.system(size: 64))
                                .foregroundColor(.gray)
                            Text("Noch keine Notizen")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    } else if gefilterteEintraege.isEmpty {
                        // Filter liefert keine Ergebnisse
                        VStack(spacing: 16) {
                            VStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 64))
                                    .foregroundColor(.gray)
                                Text("Keine Notizen gefunden")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                            Button(action: {
                                withAnimation { ausgewählteKategorie = nil }
                            }) {
                                Text("Filter zurücksetzen")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top, 50)
                    } else {
                        List {
                            ForEach(gefilterteEintraege) { eintrag in
                                NavigationLink(destination: MerklistenEintragDetail(eintrag: eintrag, viewModel: viewModel)) {
                                    NotizKarte(eintrag: eintrag)
                                        .padding(.vertical, 4)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        delete(eintrag)
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                }
                            }
                            .listRowBackground(Theme.backgroundColor)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                
                FloatingNodeMenu(
                    viewModel: viewModel,
                    isMenuOpen: $isMenuOpen,
                    isShowingNewNoteSheet: $isShowingNewNoteSheet,
                    isShowingFilterSheet: $isShowingFilterSheet,
                    isShowingCategorySheet: $isShowingCategorySheet,
                    sortierModus: $sortierModus,
                    ausgewählteKategorie: $ausgewählteKategorie
                )
                
                if isShowingFilterSheet {
                    SortingFilterSheet(isShowing: $isShowingFilterSheet, sortierModus: $sortierModus, viewModel: viewModel)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: isShowingFilterSheet)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingFilterSheet = true
                        isShowingCategorySheet = false
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .imageScale(.large)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Meine Notizen")
                            .font(.headline)
                        Text(ausgewählteKategorie != nil ? ausgewählteKategorie!.rawValue : "Alle Kategorien")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingNewNoteSheet = true
                        isShowingFilterSheet = false
                        isShowingCategorySheet = false
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewNoteSheet) {
            NeuerEintragView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingCategorySheet) {
            CategoryFilterSheet(isShowing: $isShowingCategorySheet, ausgewählteKategorie: $ausgewählteKategorie)
        }
    }
    
    private func delete(_ eintrag: MerklistenEintrag) {
        if let index = viewModel.eintraege.firstIndex(where: { $0.id == eintrag.id }) {
            withAnimation {
                viewModel.eintraege.remove(at: index)
            }
        }
    }
}
