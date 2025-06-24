//
//  ThemeButtonStyle.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 25.06.2025.
//

import SwiftUI

struct NeonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.Fonts.pixelAccent(size: 16))
            .foregroundColor(configuration.isPressed ? Theme.Colors.accent.opacity(0.7) : Theme.Colors.accent)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: Theme.Metrics.cardCornerRadius)
                    .stroke(Theme.Colors.accent, lineWidth: 2)
                    .shadow(color: Theme.Colors.accent.opacity(0.8), radius: configuration.isPressed ? 2 : 6, x: 0, y: 0)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
