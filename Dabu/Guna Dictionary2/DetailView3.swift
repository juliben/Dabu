import SwiftUI
import AVFoundation
import SwiftData

struct DetailView2: View {
    @Environment(\.modelContext) var modelContext
    @State var entry: DictionaryEntry
    var showingEnglish: Bool
    
    @State private var speechSynthesizer: AVSpeechSynthesizer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                speak(entry.phonetics)
            }) {
                Image(systemName: "speaker.3")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 10)

            Text(entry.word).font(.largeTitle)
            Text(entry.phonetics).font(.title2).foregroundColor(.secondary)
            Text(showingEnglish ? entry.english : entry.translation).font(.body)

            Button(action: {
                entry.isSaved.toggle()
                do {
                    try modelContext.save()
                } catch {
                    print("An error occurred: \(error)")
                }
                print("Saved: \(entry.isSaved ? "true" : "false"))")
            }) {
                Label(entry.isSaved ? "Unsave" : "Save", systemImage: entry.isSaved ? "bookmark.fill" : "bookmark")
                    .labelStyle(.iconOnly)
                    .foregroundColor(entry.isSaved ? .yellow : .gray)
                    .font(.title)
            }
            .padding(.top, 10)
        }
        .padding()
    }


    private func speak(_ transcription: String) {
        if speechSynthesizer == nil {
                    speechSynthesizer = AVSpeechSynthesizer()
                }
        // First, get the first phonetic transcription (before sanitization)
        let delimiters: CharacterSet = [" ", "/"]
        let firstPhonetic = transcription.components(separatedBy: delimiters).first(where: { !$0.isEmpty }) ?? transcription

        // Now apply sanitization and character replacements on the first phonetic transcription
        let sanitizedTranscription = firstPhonetic
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "[^a-zA-Z0-9 ]", with: "", options: .regularExpression)
            .replacingOccurrences(of: "gu", with: "gü")
            .replacingOccurrences(of: "gi", with: "gui")
            .replacingOccurrences(of: "ge", with: "gue")
            .replacingOccurrences(of: "gw", with: "gü")
            .replacingOccurrences(of: "sour", with: "sohur")

        guard !sanitizedTranscription.isEmpty else {
            print("No valid text to speak")
            return
        }

        let utterance = AVSpeechUtterance(string: sanitizedTranscription)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.5 
        speechSynthesizer?.speak(utterance)
    }
}
