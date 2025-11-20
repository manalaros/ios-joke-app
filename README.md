## Joke App

A small SwiftUI app that fetches a random joke and shows it with a clean MVVM + Service structure.

Key features
- Fetches a random joke from the Official Joke API
- Simple, testable MVVM + Service architecture
- Swift concurrency (async/await) and modern SwiftUI

Quick start
- Open `JokeApp/JokeApp.xcodeproj` in Xcode 15+ and run on an iOS 16+ simulator or device.

Project layout
- `Models/` — data types (`Joke`) 
- `Services/` — networking (`JokeService`)
- `ViewModels/` — app state (`JokeViewModel`)
- `Views/` — SwiftUI UI (`ContentView`)

Requirements
- iOS 16+, Xcode 15+, Swift 5.9+
