//
//  GameCoverView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 29.06.2025.
//

import SwiftUI

struct GameCoverView: View {
    let coverURL: String?
    let size: CGFloat
    var isFullWidth: Bool = false

    var body: some View {
        VStack {
            if let urlString = coverURL,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: width, height: height)
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: isFullWidth ? .fit : .fill)
                             .frame(width: width, height: height)
                             .clipped()
                             .cornerRadius(12)
                             .shadow(color: Theme.Colors.accent.opacity(0.5), radius: 6, x: 0, y: 3)
                    default:
                        fallbackEmoji(width: width, height: height)
                    }
                }
            } else {
                fallbackEmoji(width: width, height: height)
            }
        }
    }

    private var width: CGFloat {
        isFullWidth ? UIScreen.main.bounds.width - 32 : size
    }

    private var height: CGFloat {
        isFullWidth ? width * 0.56 : size
    }

    private func fallbackEmoji(width: CGFloat, height: CGFloat) -> some View {
        Text("🎮")
            .font(.system(size: min(width, height) * 0.5))
            .frame(width: width, height: height)
            .background(Theme.Colors.card)
            .cornerRadius(12)
            .shadow(color: Theme.Colors.accent.opacity(0.5), radius: 6, x: 0, y: 3)
    }
}
