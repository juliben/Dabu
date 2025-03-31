//
//  Guna_Dictionary2App.swift
//  Guna Dictionary2
//
//  Created by Julieta on 26/4/24.
//

import SwiftUI

@main

struct Guna_Dictionary2App: App {
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DictionaryEntry.self)
    }
}
