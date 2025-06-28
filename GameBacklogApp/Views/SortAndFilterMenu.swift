//
//  SortAndFilterMenu.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 28.06.2025.
//

import SwiftUI

struct SortAndFilterMenu: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: GameListViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Sort & Filter")
                    .retroTitle()
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Sort By")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    ForEach(["createdAt", "title", "platform", "rating"], id: \.self) { option in
                        Button(action: {
                            viewModel.query.sortBy = option
                            isPresented = false
                            viewModel.loadGames()
                        }) {
                            Text(option.capitalized)
                                .font(Theme.Fonts.body())
                                .foregroundColor(viewModel.query.sortBy == option ? Theme.Colors.accent : Theme.Colors.softText)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.Colors.card)
                                .cornerRadius(8)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Order")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    ForEach(["desc", "asc"], id: \.self) { option in
                        Button(action: {
                            viewModel.query.order = option
                            isPresented = false
                            viewModel.loadGames()
                        }) {
                            Text(option.capitalized)
                                .font(Theme.Fonts.body())
                                .foregroundColor(viewModel.query.order == option ? Theme.Colors.accent : Theme.Colors.softText)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.Colors.card)
                                .cornerRadius(8)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Status")
                        .font(Theme.Fonts.subtitle())
                        .foregroundColor(Theme.Colors.neonText)

                    Button(action: {
                        viewModel.query.status = nil
                        isPresented = false
                        viewModel.loadGames()
                    }) {
                        Text("All")
                            .font(Theme.Fonts.body())
                            .foregroundColor(viewModel.query.status == nil ? Theme.Colors.accent : Theme.Colors.softText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.card)
                            .cornerRadius(8)
                    }

                    ForEach(GameStatus.allCases) { status in
                        if status != .backlog {
                            Button(action: {
                                viewModel.query.status = status
                                isPresented = false
                                viewModel.loadGames()
                            }) {
                                Text(status.rawValue.capitalized)
                                    .font(Theme.Fonts.body())
                                    .foregroundColor(viewModel.query.status == status ? Theme.Colors.accent : Theme.Colors.softText)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.Colors.card)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }

                Button("Close") {
                    isPresented = false
                }
                .buttonStyle(NeonButtonStyle())
                .padding(.bottom)
            }
            .padding()
            .background(Theme.Colors.background)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
