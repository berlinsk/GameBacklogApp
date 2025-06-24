//
//  Fonts.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 25.06.2025.
//

import SwiftUI

enum Fonts {
    static func orbitron(size: CGFloat) -> Font {
        .custom("Orbitron", size: size)
    }

    static func vt323(size: CGFloat) -> Font {
        .custom("VT323", size: size)
    }

    static func cozette(size: CGFloat) -> Font {
        .custom("CozetteVector", size: size)
    }

    static func silkscreen(size: CGFloat) -> Font {
        .custom("Silkscreen", size: size)
    }

    static func pixelEmulator(size: CGFloat) -> Font {
        .custom("Pixel Emulator", size: size)
    }

    static func shareMono(size: CGFloat) -> Font {
        .custom("Share Tech Mono", size: size)
    }
}
