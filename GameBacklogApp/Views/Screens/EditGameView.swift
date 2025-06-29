//
//  EditGameView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 19.06.2025.
//

import SwiftUI

struct EditGameView: View {
    @Environment(\.dismiss) private var dismiss
    @State var game: Game
    @State private var newGenre: String = ""
    let onSave: (Game) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Edit Game")
                    .retroTitle()
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Title")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    TextField("Title", text: $game.title)
                        .font(Theme.Fonts.body())
                        .padding(10)
                        .background(Theme.Colors.card)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Platform")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    TextField("Platform", text: $game.platform)
                        .font(Theme.Fonts.body())
                        .padding(10)
                        .background(Theme.Colors.card)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Cover URL")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    TextField("Cover URL", text: Binding(
                        get: { game.coverURL ?? "" },
                        set: { game.coverURL = $0.isEmpty ? nil : $0 }
                    ))
                    .font(Theme.Fonts.body())
                    .padding(10)
                    .background(Theme.Colors.card)
                    .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Status")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                        ForEach(GameStatus.allCases, id: \.self) { status in
                            Button(action: {
                                game.status = status
                            }) {
                                Text(status.rawValue.capitalized)
                                    .font(Theme.Fonts.body())
                                    .foregroundColor(game.status == status ? Theme.Colors.accent : Theme.Colors.softText)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.Colors.card)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(game.status == status ? Theme.Colors.accent : Color.clear, lineWidth: 1.5)
                                    )
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Rating: \(game.rating)/10")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    Slider(value: Binding(
                        get: { Double(game.rating) },
                        set: { game.rating = Int($0) }
                    ), in: 0...10, step: 1)
                    .accentColor(Theme.Colors.accent)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Notes")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    TextEditor(text: $game.notes)
                        .font(Theme.Fonts.body())
                        .frame(minHeight: 100)
                        .padding(10)
                        .background(Theme.Colors.card)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Genres")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    HStack {
                        TextField("Add Genre", text: $newGenre)
                            .font(Theme.Fonts.body())
                            .padding(10)
                            .background(Theme.Colors.card)
                            .cornerRadius(8)

                        Button(action: {
                            let trimmed = newGenre.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !trimmed.isEmpty && !game.genres.contains(trimmed) {
                                game.genres.append(trimmed)
                                newGenre = ""
                            }
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(Theme.Colors.accent)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Theme.Colors.accent, lineWidth: 1.5)
                                )
                        }
                    }

                    if !game.genres.isEmpty {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                            ForEach(game.genres, id: \.self) { genre in
                                HStack {
                                    Text(genre)
                                        .retroBadge()

                                    Button(action: {
                                        game.genres.removeAll { $0 == genre }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(Theme.Colors.errorRed)
                                    }
                                }
                            }
                        }
                    }
                }

                Button("Save") {
                    onSave(game)
                    dismiss()
                }
                .buttonStyle(NeonButtonStyle())
                .padding(.top, 20)
            }
            .padding()
        }
        .background(Theme.Colors.background.ignoresSafeArea())
    }
}
