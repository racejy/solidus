//
//  FloatingNavBar.swift
//  SolidusApp
//
//  Created by racecar on 11/18/25.
//

import SwiftUI

enum Tab {
    case dashboard
    case transactions
    case budget
    
    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2.fill"
        case .transactions: return "arrow.up.arrow.down"
        case .budget: return "chart.pie.fill"
        }
    }
}

struct FloatingNavBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 40) {
            navItem(.dashboard)
            navItem(.transactions)
            navItem(.budget)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
        .background(
            SolidusGlass(color: .clear)
        )
        .solidusRounded(radius: 26, shadowOpacity: 0.15, shadowRadius: 20, shadowY: 6)
    }
    
    private func navItem(_ tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Image(systemName: tab.icon)
                .solidusIconButton(
                    size: 24,
                    color: selectedTab == tab ? .backgroundTeal : .gray
                )
        }
    }
}
