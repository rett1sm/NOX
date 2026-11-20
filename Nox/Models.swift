import SwiftUI

// MARK: - Persisted appearance choices

enum NoxDesign: String, CaseIterable, Identifiable {
    case liquidGlass = "liquid"
    case material = "material"
    case oled = "oled"
    case minimal = "minimal"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .liquidGlass: return "Liquid Glass"
        case .material: return "Material Design"
        case .oled: return "OLED Black"
        case .minimal: return "Minimal"
        }
    }

    var subtitleKey: String {
        switch self {
        case .liquidGlass: return "design.liquidDetail"
        case .material: return "design.materialDetail"
        case .oled: return "design.oledDetail"
        case .minimal: return "design.minimalDetail"
        }
    }
}

struct NoxTheme {
    let design: NoxDesign
    let accent: Color
    let cornerRadius: CGFloat
    let opacity: Double

    var background: Color {
        switch design {
        case .liquidGlass, .oled: return Color.black
        case .material: return Color(hex: "101116")
        case .minimal: return Color(hex: "090A0D")
        }
    }

    var surface: Color {
        switch design {
        case .liquidGlass: return Color.white.opacity(0.075 * opacity)
        case .material: return Color(hex: "20222B").opacity(opacity)
        case .oled: return Color(hex: "101010").opacity(opacity)
        case .minimal: return Color(hex: "15171C").opacity(opacity)
        }
    }

    var border: Color {
        design == .liquidGlass ? Color.white.opacity(0.16) : Color.white.opacity(0.07)
    }
}

enum NoxAccent: String, CaseIterable, Identifiable {
    case violet = "8B5CF6"
    case blue = "3B82F6"
    case cyan = "22D3EE"
    case green = "34D399"
    case orange = "FB923C"
    case pink = "F472B6"
    case red = "F87171"

    var id: String { rawValue }
    var color: Color { Color(hex: rawValue) }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r, g, b: UInt64
        if cleaned.count == 6 {
            r = (value >> 16) & 0xFF
            g = (value >> 8) & 0xFF
            b = value & 0xFF
        } else {
            r = 139; g = 92; b = 246
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1)
    }
}

extension View {
    func noxCard(_ theme: NoxTheme, padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
                    .fill(theme.design == .liquidGlass ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(theme.surface))
                    .overlay {
                        RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
                            .stroke(theme.border, lineWidth: 1)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous))
    }
}
