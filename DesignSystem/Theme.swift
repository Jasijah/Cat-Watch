import SwiftUI

enum Theme {
    enum Colors {
        static let platinum = Color(uiColor: .systemBackground)
        static let glassFill = Color.white.opacity(0.16)
        static let redGlow = Color(red: 0.86, green: 0.15, blue: 0.22)
        static let severityLow = Color.green
        static let severityMedium = Color.orange
        static let severityHigh = Color.red
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }

    enum Radius {
        static let card: CGFloat = 18
        static let chip: CGFloat = 10
        static let button: CGFloat = 14
    }
}

struct SeverityBadge: View {
    let severity: IncidentSeverity

    var body: some View {
        Text(severity.rawValue.capitalized)
            .font(.caption.bold())
            .padding(.horizontal, Theme.Spacing.sm)
            .padding(.vertical, Theme.Spacing.xs)
            .background(color.opacity(0.2), in: Capsule())
            .foregroundStyle(color)
            .accessibilityLabel("Severity \(severity.rawValue)")
    }

    private var color: Color {
        switch severity {
        case .low: Theme.Colors.severityLow
        case .medium: Theme.Colors.severityMedium
        case .high: Theme.Colors.severityHigh
        }
    }
}

struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
        }
        .buttonStyle(.plain)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                .stroke(Theme.Colors.redGlow.opacity(0.35), lineWidth: 1)
        )
    }
}

struct IncidentRow: View {
    let incident: Incident

    var body: some View {
        GlassCard {
            HStack(alignment: .top, spacing: Theme.Spacing.md) {
                Circle()
                    .fill(Theme.Colors.redGlow.opacity(0.25))
                    .frame(width: 10, height: 10)
                    .padding(.top, 6)

                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(incident.title)
                        .font(.headline)
                    Text("\(incident.type.rawValue.capitalized) • \(incident.city)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(incident.lastUpdated.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Spacer()
                SeverityBadge(severity: incident.severity)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(incident.title), severity \(incident.severity.rawValue), \(incident.city)")
    }
}
