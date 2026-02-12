import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var repository: IncidentRepository

    var body: some View {
        NavigationStack {
            List {
                Section("Permissions") {
                    Label("Location: When In Use", systemImage: "location")
                    Label("Notifications: Local alerts", systemImage: "bell")
                }

                Section("Alerts") {
                    Text("Configure hazard type, minimum severity, radius, and quiet hours.")
                }

                Section("Data") {
                    if repository.staleData {
                        Text("Data may be stale. Last successful refresh unavailable.")
                            .foregroundStyle(.orange)
                    } else {
                        Text("Data source healthy")
                    }
                }
            }
            .navigationTitle("Profile & Settings")
        }
    }
}
