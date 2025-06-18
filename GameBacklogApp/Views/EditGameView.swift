//
//  EditGameView.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 19.06.2025.
//

import Foundation
import SwiftUI

struct EditGameView: View {
    @Environment(\.dismiss) private var dismiss
    @State var game: Game
    let onSave: (Game) -> Void

    var body: some View {
        Form {
            Section {
                TextField("Title",    text: $game.title)
                TextField("Platform", text: $game.platform)
                TextField("Cover URL", text: Binding(
                    get: { game.coverURL ?? "" },
                    set: { game.coverURL = $0.isEmpty ? nil : $0 }
                ))
                Picker("Status", selection: $game.status) {
                    ForEach(GameStatus.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
            } header: {
                Text("Info")
            }
            
            Section {
                Stepper(value: $game.rating, in: 0...10) {
                    Text("\(game.rating)/10")
                }
            } header: {
                Text("Rating")
            }

            Section {
                TextEditor(text: $game.notes)
            } header: {
                Text("Notes")
            }

            Button("Save") {
                onSave(game)
                dismiss()
            }
        }
        .navigationTitle("Edit Game")
    }
}

extension Binding where Value == String? {
    init(_ source: Binding<String?>, replacingNilWith defaultValue: String) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
