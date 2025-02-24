//
//  FloatingNodeButton.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 13.01.25.
//

import SwiftUI

struct FloatingNodeButton: View {
    var icon: String
    var gradient: LinearGradient
    var label: String
    var action: () -> Void

    var body: some View {
        VStack(spacing: 5) {
            Button(action: action) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .frame(width: 60, height: 60)
                    .background(gradient)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
            .transition(.scale)
            .animation(.spring(), value: UUID())
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 1)
                .opacity(0.95)
        }
    }
}
