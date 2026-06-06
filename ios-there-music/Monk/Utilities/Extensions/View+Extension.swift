import SwiftUI

extension View {
    func thereCard() -> some View {
        self
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: UIConstants.cardRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }

    func thereButtonStyle() -> some View {
        self
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(ColorPalette.accent, in: Capsule())
            .foregroundStyle(.black)
    }
}

extension Date {
    var shortRelativeText: String {
        formatted(date: .abbreviated, time: .omitted)
    }
}
