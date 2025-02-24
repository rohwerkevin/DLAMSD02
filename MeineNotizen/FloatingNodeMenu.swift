//
//  FloatingNodeMenu.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//

import SwiftUI

struct FloatingNodeMenu: View {
    @ObservedObject var viewModel: MerklistenViewModel
    @Binding var isMenuOpen: Bool
    @Binding var isShowingNewNoteSheet: Bool
    @Binding var isShowingFilterSheet: Bool
    @Binding var isShowingCategorySheet: Bool
    @Binding var sortierModus: SortierModus
    @Binding var ausgewählteKategorie: Kategorie?

    let radius: CGFloat = 120

    var body: some View {
        ZStack {
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring()) { isMenuOpen = false }
                    }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        if isMenuOpen {
                            ForEach(Array(menuItems.enumerated()), id: \.element.id) { index, item in
                                FloatingNodeButton(
                                    icon: item.icon,
                                    gradient: item.gradient,
                                    label: item.label
                                ) {
                                    withAnimation {
                                        item.action()
                                    }
                                    isMenuOpen = false
                                }
                                .offset(getQuarterCirclePosition(index: index, total: menuItems.count, radius: radius))
                            }
                        }
                        FloatingNodeButton(
                            icon: isMenuOpen ? "xmark.circle.fill" : "sparkles",
                            gradient: LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            label: "Menü"
                        ) {
                            withAnimation(.spring()) { isMenuOpen.toggle() }
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private func getQuarterCirclePosition(index: Int, total: Int, radius: CGFloat) -> CGSize {
        let angle = Double(index) * (90.0 / Double(total - 1))
        let radian = CGFloat(angle) * .pi / 180
        return CGSize(width: -cos(radian) * radius, height: -sin(radian) * radius)
    }
    
    private var menuItems: [MenuItem] {
        return [
            MenuItem(
                icon: "line.horizontal.3.decrease.circle.fill",
                gradient: LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                label: "Sortierung",
                action: {
                    self.isShowingFilterSheet = true
                    self.isShowingCategorySheet = false
                }
            ),
            MenuItem(
                icon: "wand.and.stars",
                gradient: LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.teal]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                label: "Neue Notiz",
                action: {
                    self.isShowingNewNoteSheet = true
                    self.isShowingFilterSheet = false
                    self.isShowingCategorySheet = false
                }
            ),
            MenuItem(
                icon: "tag.fill",
                gradient: LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.pink]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                label: "Kategorien",
                action: {
                    self.isShowingCategorySheet = true
                    self.isShowingFilterSheet = false
                }
            )
        ]
    }
}


