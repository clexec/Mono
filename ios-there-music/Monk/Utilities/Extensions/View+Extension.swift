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

    /// Applies Liquid Glass on iOS 26+, falls back to .ultraThinMaterial on older iOS
    @ViewBuilder
    func liquidGlassBackground(cornerRadius: CGFloat) -> some View {
        #if compiler(>=6.2)
        if #available(iOS 26, *) {
            self.glassEffect(in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        #else
        self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        #endif
    }
}

extension Date {
    var shortRelativeText: String {
        formatted(date: .abbreviated, time: .omitted)
    }
}

// Liquid Glass card modifier with fallback for older iOS / older Xcode
struct LiquidGlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.liquidGlassBackground(cornerRadius: UIConstants.cardRadius)
    }
}

// Liquid Glass background modifier with fallback
struct LiquidGlassBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content.liquidGlassBackground(cornerRadius: cornerRadius)
    }
}
