//
//  ThemeModifiers.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 25.06.2025.
//

import SwiftUI

struct NeonCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Theme.Colors.card)
            .cornerRadius(Theme.Metrics.cardCornerRadius)
            .shadow(color: Theme.Colors.accent.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

struct RetroTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.title())
            .foregroundColor(Theme.Colors.neonText)
    }
}

struct RetroBadgeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.Fonts.caption())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Theme.Colors.accent.opacity(0.2))
            .cornerRadius(4)
            .foregroundColor(Theme.Colors.accent)
    }
}
