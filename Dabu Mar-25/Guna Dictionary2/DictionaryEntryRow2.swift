//
//  DictionaryEntryRow2.swift
//  Guna Dictionary2
//
//  Created by Julieta on 2/5/24.
//

import SwiftUI

struct DictionaryEntryRow2: View {
    let entry: DictionaryEntry
    var searchText: String
    var showingEnglish: Bool
    
    private func highlightedText(of content: String, searchText: String) -> Text {
        guard !searchText.isEmpty else { return Text(content) }
        guard searchText.count > 1 else { return Text(content) }
        
        let loweredContent = content.lowercased()
        let loweredSearchText = searchText.lowercased()
        
        guard let range = loweredContent.range(of: loweredSearchText) else {
            return Text(content)
        }
        
        let beforeRange = content[content.startIndex..<range.lowerBound]
        let highlighted = content[range]
        let afterRange = content[range.upperBound..<content.endIndex]
        
        return Text(beforeRange) + Text(highlighted).bold().foregroundColor(.orange) + Text(afterRange)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                highlightedText(of: entry.word, searchText: searchText).font(.headline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                if showingEnglish {
                    highlightedText(of: entry.english, searchText: searchText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                } else {
                    highlightedText(of: entry.translation, searchText: searchText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
}

