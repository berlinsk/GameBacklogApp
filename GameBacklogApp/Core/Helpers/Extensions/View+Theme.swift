//
//  View+Theme.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 25.06.2025.
//

import SwiftUI

extension View {
    func neonCard() -> some View {
        self.modifier(NeonCardModifier())
    }

    func retroTitle() -> some View {
        self.modifier(RetroTitleModifier())
    }

    func retroBadge() -> some View {
        self.modifier(RetroBadgeModifier())
    }
}
