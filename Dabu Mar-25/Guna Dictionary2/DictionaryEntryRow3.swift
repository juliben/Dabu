//
//  DictionaryEntryRow3.swift
//  Guna Dictionary2
//
//  Created by Julieta on 2/5/24.
//

import SwiftUI

    struct DictionaryEntryRow3: View {
        let entry: DictionaryEntry
        var searchText: String

        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    highlightedText(of: entry.word, searchText: searchText).font(.headline)
                }
                Spacer()
                highlightedText(of: entry.translation, searchText: searchText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    

    
    private func highlightedText(of content: String, searchText: String) -> some View {
        guard !searchText.isEmpty else { return Text(content) }
        
        let loweredContent = content.lowercased()
        let loweredSearchText = searchText.lowercased()
        
        guard let range = loweredContent.range(of: loweredSearchText) else {
            return Text(content)
        }
        
        let beforeRange = String(content[content.startIndex..<range.lowerBound])
        let highlighted = String(content[range])
        let afterRange = String(content[range.upperBound..<content.endIndex])
        
        return HStack(spacing: 0) {
            Text(beforeRange)
            Text(highlighted)
                .bold()
                .padding(2)
                .background(Color.yellow.opacity(0.5))
                .cornerRadius(4)
            Text(afterRange)
        }
    }
}
