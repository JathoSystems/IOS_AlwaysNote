//
//  ContentView.swift
//  AlwaysNote
//
//  Created by Thomas Versteeg on 14/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var noteContents = ""
    let fontSizeKey = "nl.avans.alwaysnote.fontSize"
    static let fontSizeDefault = 16.0
    @State private var fontSize = Self.fontSizeDefault {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: fontSizeKey)
        }
    }
    @State private var showAlert = false
    var body: some View {
        VStack {
            Text("AlwaysNote")
                .font(.system(size: 32, weight: .bold))
            HStack {
                Button("Save") {
                    save()
                }
                Spacer()
                Spacer()
                Button("a") {
                    decreaseFontSize()
                }
                Spacer()
                Button("A") {
                    increaseFontSize()
                }
            }
            .padding()
            TextEditor(text: $noteContents)
                .padding()
                .font(.system(size: fontSize))
        }
        .onAppear(perform: initView)
        .alert( isPresented: $showAlert, content: {
            Alert(title: Text("Your note has been stored"))
        })
    }
    func increaseFontSize() {
        fontSize = max(fontSize + 1, 24)
    }
    func decreaseFontSize() {
        fontSize = max(fontSize - 1, 12)
    }
    func initView() {
        let defaults = UserDefaults.standard
        if let savedFontSize = defaults.object(forKey: fontSizeKey) as? CGFloat {
            fontSize = savedFontSize
        }
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent("note.txt")
            noteContents = try String(contentsOf: fileURL, encoding: .utf8)
        } catch { }
    }
    func save() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent("note.txt")
            try noteContents.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch { }
        showAlert = true
    }
}

#Preview {
    ContentView()
}
