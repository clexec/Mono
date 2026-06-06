import SwiftUI

extension View {
    func thereCard() -> some View {
        self
            .padding(14)
            .glassEffect(in: .rect(cornerRadius: UIConstants.cardRadius))
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

    /// Applies Liquid Glass effect with the specified corner radius
    func liquidGlassBackground(cornerRadius: CGFloat) -> some View {
        self.glassEffect(in: .rect(cornerRadius: cornerRadius))
    }
}

extension Date {
    var shortRelativeText: String {
        formatted(date: .abbreviated, time: .omitted)
    }
}

// Liquid Glass card modifier
struct LiquidGlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.glassEffect(in: .rect(cornerRadius: UIConstants.cardRadius))
    }
}

// Liquid Glass background modifier
struct LiquidGlassBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content.glassEffect(in: .rect(cornerRadius: cornerRadius))
    }
}
