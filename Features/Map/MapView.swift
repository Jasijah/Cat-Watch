import SwiftUI
import MapKit

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
                    PrimaryButton(title: "Share Brief", systemImage: "square.and.arrow.up") { }
                    PrimaryButton(title: "Navigate", systemImage: "arrow.triangle.turn.up.right.diamond") { }
                    PrimaryButton(title: "Add Note", systemImage: "note.text") { }
                    PrimaryButton(title: "Add to Checklist", systemImage: "checkmark.circle") { }
                }
                .padding()
            }
            .navigationTitle("Incident Detail")
        }
    }
}
