//
//  GameDetailView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 19.06.2025.
//

import SwiftUI

struct GameDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var game: Game
    let onEdit: (Game) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let url = URL(string: game.coverURL ?? "") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable()
                               .scaledToFit()
                               .cornerRadius(12)
                        case .failure:
                            Color.gray.frame(height: 180)
                        default:
                            ProgressView().frame(height: 180)
                        }
                    }
                } else {
                    Color.gray.frame(height: 180)
                        .cornerRadius(12)
                }

                Group {
                    Text(game.title).font(.title2).bold()
                    Text("Platform: \(game.platform)")
                    Text("Status: \(game.status.rawValue.capitalized)")
                    Text("Rating: \(game.rating)/10")
                    if !game.genres.isEmpty {
                        Text("Genres: \(game.genres.joined(separator: ", "))")
                    }
                    if !game.notes.isEmpty {
                        Text("Notes:")
                        Text(game.notes).italic()
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .toolbar {
            Button("Edit") { onEdit(game) }
        }
    }
}
