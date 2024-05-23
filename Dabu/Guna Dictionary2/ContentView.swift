//
//  ContentView.swift
//  Guna Dictionary2
//
//  Created by Julieta on 26/4/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var entries = [DictionaryEntry]()
    @State private var searchText = ""
    @State var showingEnglish = true
    
    
    var filteredEntries: [DictionaryEntry] {
        let fieldToSearch = showingEnglish ? \DictionaryEntry.english : \DictionaryEntry.translation
        
        let normalizedSearchText = searchText.replacingOccurrences(of: " ", with: "").lowercased()
        if normalizedSearchText.count < 2 {
            return entries // Don't show search results until there's at least 2 characters in the search
        }
        let sortedEntries = entries.filter { entry in
            let normalizedWord = entry.word.replacingOccurrences(of: " ", with: "").lowercased()
            let normalizedTranslation = entry[keyPath: fieldToSearch].replacingOccurrences(of: " ", with: "").lowercased()
            
            // Check if the search text is found within either the Guna word or the translation
            return normalizedSearchText.isEmpty ||
            normalizedWord.contains(normalizedSearchText) ||
            normalizedTranslation.contains(normalizedSearchText)
        }.sorted { (entry1, entry2) -> Bool in
            let normalizedEntry1Word = entry1.word.replacingOccurrences(of: " ", with: "").lowercased()
            let normalizedEntry2Word = entry2.word.replacingOccurrences(of: " ", with: "").lowercased()
            let normalizedEntry1Translation = entry1[keyPath: fieldToSearch].replacingOccurrences(of: " ", with: "").lowercased()
            let normalizedEntry2Translation = entry2[keyPath: fieldToSearch].replacingOccurrences(of: " ", with: "").lowercased()
            
            // Show exact word matches first
            let entry1WordMatches = normalizedEntry1Word == normalizedSearchText
            let entry2WordMatches = normalizedEntry2Word == normalizedSearchText
            
            if entry1WordMatches != entry2WordMatches {
                return entry1WordMatches
            }
            
            // If word matches are the same, show exact translation matches
            let entry1TranslationMatches = normalizedEntry1Translation == normalizedSearchText
            let entry2TranslationMatches = normalizedEntry2Translation == normalizedSearchText
            
            if entry1TranslationMatches != entry2TranslationMatches {
                return entry1TranslationMatches
            }
            
            // Fallback to alphabetical order
            return normalizedEntry1Word < normalizedEntry2Word
        }
        
        return sortedEntries
    }
    
    
    
    var body: some View {
        NavigationStack {
            List(filteredEntries, id: \.id) { entry in
                NavigationLink(destination: DetailView2(entry: entry, showingEnglish: showingEnglish)) {
                    DictionaryEntryRow2(entry: entry, searchText: searchText, showingEnglish: showingEnglish)
                }
            }
            .listStyle(.plain)
            .onAppear {
                fetchEntries()
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: showingEnglish ? "Search" : "Buscar")
            .navigationTitle(showingEnglish ? "Guna Dictionary" : "Diccionario Guna")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SavedWordsView(showingEnglish: showingEnglish)) {
                        Text(showingEnglish ? "Saved Words" : "Favoritos")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingEnglish.toggle()
                    }) {
                        Text(showingEnglish ? "EN" : "ES")
                            .fontWeight(.bold)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                            .background(showingEnglish ? Color.blue : Color.red)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .shadow(radius: 1)
                    }
                }
            }
        }
    }
    
    func fetchEntries() {
        guard entries.isEmpty else { return }
        if let url = Bundle.main.url(forResource: "CompleteDictionary", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedEntries = try decoder.decode([DictionaryEntry].self, from: data)
                entries = decodedEntries
                for entry in decodedEntries {
                    modelContext.insert(entry)
                }
            } catch {
                print("Failed to decode entries: \(error)")
            }
        } else {
            print("JSON file not found.")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DictionaryEntry.self)
}


