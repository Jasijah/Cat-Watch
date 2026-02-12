import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var repository: IncidentRepository
    @State private var selectedHazard: HazardType?
    @State private var selectedSeverity: IncidentSeverity?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Hazard", selection: $selectedHazard) {
                        Text("All").tag(HazardType?.none)
                        ForEach(HazardType.allCases) { hazard in
                            Text(hazard.rawValue.capitalized).tag(HazardType?.some(hazard))
                        }
                    }

                    Picker("Severity", selection: $selectedSeverity) {
                        Text("All").tag(IncidentSeverity?.none)
                        ForEach(IncidentSeverity.allCases) { severity in
                            Text(severity.rawValue.capitalized).tag(IncidentSeverity?.some(severity))
                        }
                    }
                }

                Section("Incidents") {
                    ForEach(repository.filtered(hazard: selectedHazard, severity: selectedSeverity)) { incident in
                        IncidentRow(incident: incident)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, Theme.Spacing.xs)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Feed")
            .safeAreaInset(edge: .bottom) {
                if let updated = repository.lastUpdated {
                    Text("Last updated \(updated.formatted(date: .omitted, time: .standard))")
                        .font(.caption)
                        .padding(8)
                        .background(.thinMaterial, in: Capsule())
                        .padding(.bottom, 8)
                }
            }
            .task { await repository.refresh() }
        }
    }
}
