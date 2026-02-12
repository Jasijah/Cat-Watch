import Foundation
import SwiftData

@Model
final class ChecklistItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var isComplete: Bool
    var incidentID: UUID?
    var createdAt: Date

    init(id: UUID = UUID(), title: String, isComplete: Bool = false, incidentID: UUID? = nil, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.incidentID = incidentID
        self.createdAt = createdAt
    }
}
