import SwiftUI

struct GlowAccent: ViewModifier {
    var color: Color = Theme.Colors.redGlow
    var radius: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.28), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.15), radius: radius * 1.8, x: 0, y: 1)
    }
}

extension View {
    func glowAccent(color: Color = Theme.Colors.redGlow, radius: CGFloat = 10) -> some View {
        modifier(GlowAccent(color: color, radius: radius))
    }
}
