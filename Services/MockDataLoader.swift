import Foundation

struct MockDataLoader: SourceAdapter {
    let sourceName: String = "BundledMockJSON"
    private struct IncidentDTO: Decodable {
        let id: UUID
        let title: String
        let type: HazardType
        let severity: IncidentSeverity
        let latitude: Double
        let longitude: Double
        let city: String
        let affectedArea: String
        let sourceLabel: String
        let lastUpdated: Date
        let details: String
    }

    func fetchIncidents() async throws -> [Incident] {
        try await loadIncidents()
    }

    // TODO: Replace bundled file logic with real API adapter(s) that conform to SourceAdapter.
    func loadIncidents(filename: String = "mock_incidents") async throws -> [Incident] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "MockDataLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing bundled mock JSON"])
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let rows = try decoder.decode([IncidentDTO].self, from: data)

        return rows.map {
            Incident(
                id: $0.id,
                title: $0.title,
                type: $0.type,
                severity: $0.severity,
                latitude: $0.latitude,
                longitude: $0.longitude,
                city: $0.city,
                affectedArea: $0.affectedArea,
                sourceLabel: $0.sourceLabel,
                lastUpdated: $0.lastUpdated,
                details: $0.details
            )
        }
    }
}
