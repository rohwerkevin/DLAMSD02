//
//  SortingFilterSheet.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//
import SwiftUI

struct SortingFilterSheet: View {
    @Binding var isShowing: Bool
    @Binding var sortierModus: SortierModus
    @ObservedObject var viewModel: MerklistenViewModel

    var body: some View {
        ZStack {
            if isShowing {
                Color.clear
                    .background(.ultraThinMaterial)
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isShowing = false }
                    }
            }
            
            VStack(spacing: 12) {
                Capsule()
                    .frame(width: 40, height: 4)
                    .foregroundColor(Color.secondary.opacity(0.5))
                    .padding(.top, 8)
                
                Text("Filter & Sortierung")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sortieren nach:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Picker("", selection: $sortierModus) {
                        Text("📅 Datum").tag(SortierModus.datum)
                        Text("🔤 Titel").tag(SortierModus.titel)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: sortierModus) { newValue in
                        viewModel.sortierModus = newValue
                    }
                }
                .padding(.horizontal)
                
                // Anwenden & Schließen Button
                Button(action: {
                    withAnimation { isShowing = false }
                }) {
                    Text("Anwenden & Schließen")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .offset(y: isShowing ? 0 : UIScreen.main.bounds.height)
            .transition(.move(edge: .bottom))
            .animation(.spring(), value: isShowing)
        }
    }
}
