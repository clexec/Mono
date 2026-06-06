import SwiftUI

extension View {
    func thereCard() -> some View {
        self
            .padding(14)
            .modifier(LiquidGlassCardModifier())
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

// Liquid Glass card modifier with fallback for older iOS
struct LiquidGlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content.glassEffect(in: .rect(cornerRadius: UIConstants.cardRadius))
        } else {
            content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cardRadius, style: .continuous))
        }
    }
}

// Liquid Glass background modifier with fallback
struct LiquidGlassBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content.glassEffect(in: .rect(cornerRadius: cornerRadius))
        } else {
            content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}
