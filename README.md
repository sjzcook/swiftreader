# SwiftReader

A native iOS reading app inspired by the feature set and modern reading experience of Legado with MD3, implemented independently with Swift and SwiftUI.

## Project goals

- Native SwiftUI interface for iPhone and iPad
- Local EPUB and TXT import
- Bookshelf, reading progress, bookmarks, and table of contents
- Customizable typography and reading themes
- Extensible source/rule parsing layer for lawful user-configured web sources
- Automated iOS Simulator build with GitHub Actions

## Status

Early scaffold. Core reading and parsing features will be added incrementally. This project does not bundle third-party book content or source rules.

## Requirements

- Xcode 16 or newer
- iOS 17+

## Build

Open `SwiftReader.xcodeproj` in Xcode once the project file is generated, or run the GitHub Actions workflow to validate the source build.
