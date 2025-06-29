//
//  Theme.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 24.06.2025.
//

import SwiftUI
typealias FontSet = Fonts

enum Theme {
    
    enum Colors {
        static let background     = Color("Background")
        static let card           = Color("Card")
        static let accent         = Color("AccentGame")
        static let neonText       = Color("NeonText")
        static let softText       = Color("SoftText")
        static let errorRed       = Color.red
        static let successGreen   = Color.green
    }
    
    enum Fonts {
        static func title(size: CGFloat = 26) -> Font {
            FontSet.orbitron(size: size)
        }
        
        static func subtitle(size: CGFloat = 20) -> Font {
            FontSet.shareMono(size: size)
        }
        static func body(size: CGFloat = 16) -> Font {
            FontSet.vt323(size: size)
        }
        static func caption(size: CGFloat = 13) -> Font {
            FontSet.cozette(size: size)
        }
        static func pixelAccent(size: CGFloat = 15) -> Font {
            FontSet.pixelEmulator(size: size)
        }
        static func monoTiny(size: CGFloat = 12) -> Font {
            FontSet.silkscreen(size: size)
        }
    }
    
    enum Metrics {
        static let cardCornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 10
    }
}
