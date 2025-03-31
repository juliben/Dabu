//
//  DictionaryEntryRow.swift
//  Guna Dictionary2
//
//  Created by Julieta on 26/4/24.
//

import SwiftUI

struct DictionaryEntryRow: View {
    let entry: DictionaryEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.word).font(.headline)
            }
            Spacer()
            Text(entry.translation).font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.trailing)
        }
    }
}

