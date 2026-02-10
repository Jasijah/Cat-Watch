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
            for row in existing {
                context.delete(row)
            }
            for incident in remote {
                context.insert(incident)
            }
            try context.save()
            incidents = remote.sorted(by: { $0.lastUpdated > $1.lastUpdated })
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
