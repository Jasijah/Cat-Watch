import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @EnvironmentObject private var repository: IncidentRepository
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.35),
        span: MKCoordinateSpan(latitudeDelta: 18, longitudeDelta: 18)
    )
    @State private var selectedIncident: Incident?

    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: repository.incidents) { incident in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: incident.latitude, longitude: incident.longitude)) {
                    Button {
                        selectedIncident = incident
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.Colors.redGlow)
                            .glowAccent(radius: 8)
                    }
                    .accessibilityLabel("Open details for \(incident.title)")
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .navigationTitle("Live Map")
            .task { await repository.refresh() }
            .sheet(item: $selectedIncident) { incident in
                IncidentDetailSheet(incident: incident)
            }
        }
    }
}

private struct IncidentDetailSheet: View {
    @EnvironmentObject private var repository: IncidentRepository
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var noteText: String = ""

    let incident: Incident

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text(incident.title)
                                .font(.title3.bold())
                            SeverityBadge(severity: incident.severity)
                            Text("Affected Area: \(incident.affectedArea)")
                            Text("Source: \(incident.sourceLabel)")
                            Text("Updated: \(incident.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                                .foregroundStyle(.secondary)
                        }
                    }

                    PrimaryButton(title: incident.isSaved ? "Remove from Watchlist" : "Save", systemImage: "star") {
                        repository.toggleSaved(incident)
                    }

                    ShareLink(item: shareBrief) {
                        Label("Share Brief", systemImage: "square.and.arrow.up")
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

                    Link(destination: navigationURL) {
                        Label("Navigate", systemImage: "arrow.triangle.turn.up.right.diamond")
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

                    GlassCard {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Quick Note")
                                .font(.headline)
                            TextField("Add a field note", text: $noteText, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                            PrimaryButton(title: "Add Note", systemImage: "note.text") {
                                addNote()
                            }
                        }
                    }

                    PrimaryButton(title: "Add to Checklist", systemImage: "checkmark.circle") {
                        modelContext.insert(ChecklistItem(title: "Deploy to \(incident.city)", incidentID: incident.id))
                        try? modelContext.save()
                        dismiss()
                    }
                }
                .padding()
            }
            .navigationTitle("Incident Detail")
        }
    }

    private var navigationURL: URL {
        URL(string: "http://maps.apple.com/?ll=\(incident.latitude),\(incident.longitude)")!
    }

    private var shareBrief: String {
        """
        CATWatch Brief
        Incident: \(incident.title)
        Type: \(incident.type.rawValue.capitalized)
        Severity: \(incident.severity.rawValue.capitalized)
        Area: \(incident.affectedArea)
        City: \(incident.city)
        Updated: \(incident.lastUpdated.formatted(date: .abbreviated, time: .shortened))
        Source: \(incident.sourceLabel)
        """
    }

    private func addNote() {
        let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        modelContext.insert(Note(incidentID: incident.id, text: trimmed))
        try? modelContext.save()
        noteText = ""
    }
}
