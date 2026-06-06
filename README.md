# THERE Music

<div align="center">
  <img src="ios-there-music/Monk/Assets.xcassets/AppIcon.appiconset/icon.png" alt="THERE Music Logo" width="120" height="120">
  
  <p><strong>Open-source iOS music streaming application</strong></p>
  
  [![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg)](https://developer.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-purple.svg)](https://developer.apple.com/xcode/swiftui/)
</div>

---

## Screenshots

<div align="center">
  <img src="screenshots/iphone/en/01_authentication.png" width="200" alt="Authentication">
  <img src="screenshots/iphone/en/02_home_feed.png" width="200" alt="Home Feed">
  <img src="screenshots/iphone/en/03_search.png" width="200" alt="Search">
  <img src="screenshots/iphone/en/04_full_player.png" width="200" alt="Full Player">
</div>

<div align="center">
  <img src="screenshots/iphone/en/05_queue.png" width="200" alt="Queue">
  <img src="screenshots/iphone/en/06_your_library.png" width="200" alt="Your Library">
</div>

---

## About

THERE Music is an open-source iOS music streaming application built with SwiftUI. Supports **Spotify API** and **SoundCloud API** for music playback and discovery.

### Features

- Authentication via Apple, Google, or Email/Password
- Personalized home feed with recommendations
- Real-time search with genre filtering
- Library management for songs, albums, and playlists
- Full-featured audio player with queue management
- Track comments and social features
- Dark theme with warm brown color palette

---

## Tech Stack

**Frameworks**

![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-blue?logo=swift&logoColor=white)
![Combine](https://img.shields.io/badge/Combine-Framework-orange?logo=swift&logoColor=white)
![AVFoundation](https://img.shields.io/badge/AVFoundation-Audio-red?logo=apple&logoColor=white)
![CoreData](https://img.shields.io/badge/CoreData-Persistence-green?logo=apple&logoColor=white)

- SwiftUI for UI
- Combine for reactive state management
- AVFoundation for audio playback
- CoreData for local persistence
- AuthenticationServices for Sign in with Apple
- CryptoKit for password hashing
- Keychain for secure token storage

**Architecture**

- MVVM (Model-View-ViewModel)
- Repository Pattern
- Dependency Injection
- async/await for concurrency

**APIs**

- Spotify API
- SoundCloud API
- iTunes Search API
- Last.fm API

---

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

---

## Installation

**1. Clone the repository**

```bash
git clone https://github.com/clexec/Mono.git
cd Mono
```

**2. Open in Xcode**

```bash
open ios-there-music/Monk.xcodeproj
```

**3. Configure API keys**

Create `Config.swift` in the project:

```swift
enum APIConfig {
    static let spotifyClientID = "YOUR_SPOTIFY_CLIENT_ID"
    static let spotifyClientSecret = "YOUR_SPOTIFY_CLIENT_SECRET"
    static let soundCloudClientID = "YOUR_SOUNDCLOUD_CLIENT_ID"
    static let lastFMAPIKey = "YOUR_LASTFM_API_KEY"
}
```

**4. Build and run**

Press `Cmd + R` in Xcode

### API Keys

- Spotify: [developer.spotify.com](https://developer.spotify.com/)
- SoundCloud: [developers.soundcloud.com](https://developers.soundcloud.com/)
- Last.fm: [last.fm/api](https://www.last.fm/api)

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Acknowledgments

Built with Apple's native frameworks. Music data provided by Spotify, SoundCloud, iTunes, and Last.fm APIs.

---

<div align="center">
  <p>Made with SwiftUI</p>
</div>
