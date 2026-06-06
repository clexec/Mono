# THERE Music 🎵

<div align="center">
  <img src="ios-there-music/Monk/Assets.xcassets/AppIcon.appiconset/icon.png" alt="THERE Music Logo" width="120" height="120">
  
  <p><strong>A beautiful, open-source iOS music streaming app</strong></p>
  
  [![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg)](https://developer.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-purple.svg)](https://developer.apple.com/xcode/swiftui/)
</div>

---

## 📱 Screenshots

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

## 🎯 About

**THERE Music** is an open-source iOS music streaming application built with SwiftUI. It provides a modern, elegant interface for discovering and playing music from multiple sources including **Spotify API** and **SoundCloud API**.

### ✨ Key Features

- 🎨 **Beautiful Design** — Warm brown color palette with dark theme by default
- 🔐 **Multiple Auth Options** — Sign in with Apple, Google, or Email/Password
- 🏠 **Personalized Home Feed** — Discover Weekly, Release Radar, Daily Mixes
- 🔍 **Advanced Search** — Real-time search with genre categories
- 📚 **Your Library** — Liked songs, albums, playlists, and artists
- 🎧 **Full-Featured Player** — Mini player, full-screen player with queue management
- 💬 **Track Comments** — Add and view comments on your favorite tracks
- 🎵 **Audio Visualizer** — Real-time audio visualization
- ⚡ **Smooth Animations** — Native iOS glass effects and spring animations

---

## 🛠 Tech Stack

### Frameworks & Libraries

![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-blue?logo=swift&logoColor=white)
![Combine](https://img.shields.io/badge/Combine-Framework-orange?logo=swift&logoColor=white)
![AVFoundation](https://img.shields.io/badge/AVFoundation-Audio-red?logo=apple&logoColor=white)
![CoreData](https://img.shields.io/badge/CoreData-Persistence-green?logo=apple&logoColor=white)

- **SwiftUI** — Modern declarative UI framework
- **Combine** — Reactive programming for state management
- **AVFoundation** — Audio playback and processing
- **CoreData** — Local data persistence
- **AuthenticationServices** — Sign in with Apple
- **CryptoKit** — Secure password hashing
- **Keychain** — Secure token storage

### Architecture

- **MVVM** (Model-View-ViewModel)
- **Repository Pattern** — Data abstraction layer
- **Dependency Injection** — Clean, testable code
- **async/await** — Modern concurrency

### APIs

- **Spotify API** — Music catalog and streaming
- **SoundCloud API** — Additional music content
- **iTunes Search API** — Track previews and metadata
- **Last.fm API** — Artist information and recommendations

---

## 📋 Requirements

- **iOS 17.0+**
- **Xcode 15.0+**
- **Swift 5.9+**
- **CocoaPods** or **Swift Package Manager** (for dependencies)

---

## 🚀 Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/there-music.git
   cd there-music
   ```

2. **Open the project in Xcode**
   ```bash
   open ios-there-music/Monk.xcodeproj
   ```

3. **Configure API Keys**
   
   Create a `Config.swift` file in the project and add your API keys:
   ```swift
   enum APIConfig {
       static let spotifyClientID = "YOUR_SPOTIFY_CLIENT_ID"
       static let spotifyClientSecret = "YOUR_SPOTIFY_CLIENT_SECRET"
       static let soundCloudClientID = "YOUR_SOUNDCLOUD_CLIENT_ID"
       static let lastFMAPIKey = "YOUR_LASTFM_API_KEY"
   }
   ```

4. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Getting API Keys

- **Spotify API**: [developer.spotify.com](https://developer.spotify.com/)
- **SoundCloud API**: [developers.soundcloud.com](https://developers.soundcloud.com/)
- **Last.fm API**: [last.fm/api](https://www.last.fm/api)

---

## 📁 Project Structure

```
ios-there-music/
├── Monk/
│   ├── Authentication/      # Auth screens and logic
│   ├── Models/             # Data models
│   ├── Services/           # API clients and services
│   ├── ViewModels/         # Business logic
│   ├── Views/              # SwiftUI views
│   ├── Managers/           # App-level managers
│   ├── Repositories/       # Data repositories
│   └── Utilities/          # Helpers and extensions
├── MonkTests/              # Unit tests
├── MonkUITests/            # UI tests
└── screenshots/            # App Store screenshots
```

---

## 🎨 Design Philosophy

THERE Music embraces a **warm, minimalist aesthetic** with:

- **Color Palette**: Warm browns (#D4A574, #6B4423) instead of traditional music app greens
- **Typography**: SF Pro with clear hierarchy
- **Iconography**: SF Symbols for consistency
- **Motion**: Subtle spring animations for delightful interactions
- **Glassmorphism**: iOS native blur effects throughout

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create your feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and development process.

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by Spotify's excellent UX design
- Built with Apple's native frameworks for optimal performance
- Music data provided by Spotify, SoundCloud, iTunes, and Last.fm APIs

---

## 📧 Contact

For questions, suggestions, or feedback:

- **GitHub Issues**: [Create an issue](https://github.com/yourusername/there-music/issues)
- **Email**: your.email@example.com
- **Twitter**: [@yourusername](https://twitter.com/yourusername)

---

<div align="center">
  <p>Made with ❤️ and SwiftUI</p>
  <p>⭐ Star this repo if you like it!</p>
</div>
