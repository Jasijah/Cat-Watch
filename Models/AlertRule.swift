import Foundation
import SwiftData

@Model
final class AlertRule {
    @Attribute(.unique) var id: UUID
    var name: String
    var hazardTypes: [HazardType]
    var minSeverity: IncidentSeverity
    var quietHoursStart: Int
    var quietHoursEnd: Int
    var enabled: Bool

    init(
        id: UUID = UUID(),
        name: String,
        hazardTypes: [HazardType],
        minSeverity: IncidentSeverity,
        quietHoursStart: Int = 22,
        quietHoursEnd: Int = 6,
        enabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.hazardTypes = hazardTypes
        self.minSeverity = minSeverity
        self.quietHoursStart = quietHoursStart
        self.quietHoursEnd = quietHoursEnd
        self.enabled = enabled
    }
}
