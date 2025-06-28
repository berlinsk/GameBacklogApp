//
//  GameDetailView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 19.06.2025.
//

import SwiftUI

struct GameDetailView: View {
    @Binding var game: Game
    let onEdit: (Game) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                if let url = URL(string: game.coverURL ?? "") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable()
                               .scaledToFit()
                               .cornerRadius(12)
                               .shadow(color: Theme.Colors.accent.opacity(0.5), radius: 6, x: 0, y: 3)
                        case .failure:
                            Color.gray.frame(height: 180)
                                .cornerRadius(12)
                        default:
                            ProgressView()
                                .frame(height: 180)
                        }
                    }
                } else {
                    Color.gray.frame(height: 180)
                        .cornerRadius(12)
                }

                Text(game.title)
                    .retroTitle()
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Platform:")
                            .font(Theme.Fonts.subtitle(size: 18))
                            .foregroundColor(Theme.Colors.neonText)
                        Spacer()
                        Text(game.platform)
                            .font(Theme.Fonts.body(size: 18))
                            .foregroundColor(Theme.Colors.softText)
                    }

                    HStack {
                        Text("Status:")
                            .font(Theme.Fonts.subtitle(size: 18))
                            .foregroundColor(Theme.Colors.neonText)
                        Spacer()
                        Text(game.status.rawValue.capitalized)
                            .font(Theme.Fonts.body(size: 18))
                            .foregroundColor(Theme.Colors.softText)
                    }

                    HStack {
                        Text("Rating:")
                            .font(Theme.Fonts.subtitle(size: 18))
                            .foregroundColor(Theme.Colors.neonText)
                        Spacer()
                        Text("\(game.rating)/10")
                            .font(Theme.Fonts.body(size: 18))
                            .foregroundColor(Theme.Colors.softText)
                    }

                    if !game.genres.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Genres:")
                                .font(Theme.Fonts.subtitle(size: 18))
                                .foregroundColor(Theme.Colors.neonText)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                                ForEach(game.genres, id: \.self) { genre in
                                    Text(genre)
                                        .retroBadge()
                                }
                            }
                        }
                    }

                    if !game.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notes:")
                                .font(Theme.Fonts.subtitle(size: 18))
                                .foregroundColor(Theme.Colors.neonText)

                            Text(game.notes)
                                .font(Theme.Fonts.body())
                                .foregroundColor(Theme.Colors.softText)
                                .padding(10)
                                .background(Theme.Colors.card)
                                .cornerRadius(8)
                        }
                    }
                }
                .neonCard()

                Button("Edit") {
                    onEdit(game)
                }
                .buttonStyle(NeonButtonStyle())
                .padding(.top, 20)

                Spacer()
            }
            .padding()
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Details")
    }
}
