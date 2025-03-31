//
//  SavedWordsView.swift
//  Guna Dictionary2
//
//  Created by Julieta on 26/4/24.
//

import SwiftUI
import SwiftData

struct SavedWordsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query var entries: [DictionaryEntry]
    var showingEnglish: Bool
    
    var body: some View {
        List(entries.filter { $0.isSaved }, id: \.id) { entry in
            NavigationLink(destination: DetailView2(entry: entry, showingEnglish: showingEnglish)) {
                DictionaryEntryRow2(entry: entry, searchText: "", showingEnglish: showingEnglish)
            }
        }
        .navigationTitle(showingEnglish ? "Saved Words" : "Favoritos")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(showingEnglish ? "Back" : "Atrás")
                    }
                }
            }
        }
    }
}


