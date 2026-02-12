import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject private var repository: IncidentRepository

    var body: some View {
        NavigationStack {
            List {
                Section("Saved Incidents") {
                    if repository.watchlist.isEmpty {
                        Text("No saved incidents yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(repository.watchlist) { incident in
                            IncidentRow(incident: incident)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
            }
            .navigationTitle("Watchlist")
            .task { await repository.refresh() }
        }
    }
}
