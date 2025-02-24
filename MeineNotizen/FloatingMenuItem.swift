//
//  MenuItem.swift
//  MeineNotizen
//
//  Created by Kevin Rohwer on 17.02.25.
//

import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let gradient: LinearGradient
    let label: String
    let action: () -> Void
}
