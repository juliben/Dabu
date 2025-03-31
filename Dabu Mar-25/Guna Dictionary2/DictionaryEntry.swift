//
//  DictionaryEntry.swift
//  Guna Dictionary2
//
//  Created by Julieta on 29/4/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class DictionaryEntry: Codable {
    var id: UUID
    var word: String
    var translation: String
    var phonetics: String
    var isSaved: Bool
    var english: String

    enum CodingKeys: String, CodingKey {
            case id, word, translation, phonetics, isSaved, english
        }
    required init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        word = try container.decode(String.self, forKey: .word)
        translation = try container.decode(String.self, forKey: .translation)
        phonetics = try container.decode(String.self, forKey: .phonetics)
        isSaved = try container.decode(Bool.self, forKey: .isSaved)
        english = try container.decode(String.self, forKey: .english)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(word, forKey: .word)
        try container.encode(translation, forKey: .translation)
        try container.encode(phonetics, forKey: .phonetics)
        try container.encode(isSaved, forKey: .isSaved)
        try container.encode(english, forKey: .english)
    }
}
