import SwiftUI

nonisolated enum AppConstants {
    static let appName = "THERE Music"
    static let appDescription = "Music that feels close. Discover, play, save, and share the tracks that move with you."
    static let googleClientID = ""
}

nonisolated enum ColorPalette {
    static let background = Color.black
    static let surface = Color(red: 0.06, green: 0.05, blue: 0.04)
    static let elevated = Color(red: 0.12, green: 0.09, blue: 0.07)
    static let accent = Color(red: 0.831, green: 0.647, blue: 0.455)
    static let accentAlt = Color(red: 0.788, green: 0.663, blue: 0.380)
    static let secondary = Color(red: 0.420, green: 0.267, blue: 0.137)
    static let textSecondary = Color(red: 0.702, green: 0.702, blue: 0.702)
}

nonisolated enum UIConstants {
    static let horizontalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 18
    static let cardRadius: CGFloat = 14
}
