import Foundation
import SwiftData

enum HazardType: String, Codable, CaseIterable, Identifiable {
    case wildfire
    case flood
    case hurricane
    case hail
    case tornado
    case earthquake

    var id: String { rawValue }
}

enum IncidentSeverity: String, Codable, CaseIterable, Identifiable {
    case low
    case medium
    case high

    var id: String { rawValue }
}

@Model
final class Incident {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: HazardType
    var severity: IncidentSeverity
    var latitude: Double
    var longitude: Double
    var city: String
    var affectedArea: String
    var sourceLabel: String
    var lastUpdated: Date
    var details: String
    var isSaved: Bool

    init(
        id: UUID = UUID(),
        title: String,
        type: HazardType,
        severity: IncidentSeverity,
        latitude: Double,
        longitude: Double,
        city: String,
        affectedArea: String,
        sourceLabel: String,
        lastUpdated: Date,
        details: String,
        isSaved: Bool = false
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.severity = severity
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.affectedArea = affectedArea
        self.sourceLabel = sourceLabel
        self.lastUpdated = lastUpdated
        self.details = details
        self.isSaved = isSaved
    }
}
