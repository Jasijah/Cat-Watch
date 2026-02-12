import Foundation
import SwiftData


protocol SourceAdapter {
    var sourceName: String { get }
    func fetchIncidents() async throws -> [Incident]
}

@MainActor
final class IncidentRepository: ObservableObject {
    @Published private(set) var incidents: [Incident] = []
    @Published private(set) var lastUpdated: Date?
    @Published var staleData: Bool = false

    private let sourceAdapter: SourceAdapter
    private let context: ModelContext

    init(loader: SourceAdapter, context: ModelContext) {
        self.sourceAdapter = loader
        self.context = context
    }

    func refresh() async {
        do {
            let remote = try await sourceAdapter.fetchIncidents()
            let existing = try context.fetch(FetchDescriptor<Incident>())
            let existingByID = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })

            for incoming in remote {
                if let stored = existingByID[incoming.id] {
                    // Preserve local user state while refreshing server fields.
                    let savedState = stored.isSaved
                    stored.title = incoming.title
                    stored.type = incoming.type
                    stored.severity = incoming.severity
                    stored.latitude = incoming.latitude
                    stored.longitude = incoming.longitude
                    stored.city = incoming.city
                    stored.affectedArea = incoming.affectedArea
                    stored.sourceLabel = incoming.sourceLabel
                    stored.lastUpdated = incoming.lastUpdated
                    stored.details = incoming.details
                    stored.isSaved = savedState
                } else {
                    context.insert(incoming)
                }
            }

            let incomingIDs = Set(remote.map(\.id))
            for item in existing where !incomingIDs.contains(item.id) {
                context.delete(item)
            }

            try context.save()
            incidents = ((try? context.fetch(FetchDescriptor<Incident>())) ?? [])
                .sorted(by: { $0.lastUpdated > $1.lastUpdated })
            lastUpdated = .now
            staleData = false
        } catch {
            incidents = (try? context.fetch(FetchDescriptor<Incident>())) ?? []
            staleData = true
        }
    }

    func toggleSaved(_ incident: Incident) {
        incident.isSaved.toggle()
        try? context.save()
        objectWillChange.send()
    }

    var watchlist: [Incident] {
        incidents.filter(\.isSaved)
    }

    func filtered(
        hazard: HazardType?,
        severity: IncidentSeverity?
    ) -> [Incident] {
        incidents.filter { item in
            let hazardMatch = hazard == nil || item.type == hazard
            let severityMatch = severity == nil || item.severity == severity
            return hazardMatch && severityMatch
        }
    }
}
