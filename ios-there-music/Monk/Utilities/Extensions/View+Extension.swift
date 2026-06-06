import SwiftUI

extension View {
    func thereCard() -> some View {
        self
            .padding(14)
            #if compiler(>=6.2)
            if #available(iOS 26, *) {
                self.glassEffect(in: .rect(cornerRadius: UIConstants.cardRadius))
            } else {
                self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cardRadius, style: .continuous))
            }
            #else
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cardRadius, style: .continuous))
            #endif
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
    /// On Xcode 26+ / iOS 26: uses real .glassEffect()
    /// On older compilers / iOS: falls back to .ultraThinMaterial
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

// Liquid Glass card modifier
struct LiquidGlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        #if compiler(>=6.2)
        if #available(iOS 26, *) {
            content.glassEffect(in: .rect(cornerRadius: UIConstants.cardRadius))
        } else {
            content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cardRadius, style: .continuous))
        }
        #else
        content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cardRadius, style: .continuous))
        #endif
    }
}

// Liquid Glass background modifier
struct LiquidGlassBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        #if compiler(>=6.2)
        if #available(iOS 26, *) {
            content.glassEffect(in: .rect(cornerRadius: cornerRadius))
        } else {
            content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        #else
        content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        #endif
    }
}
