import Foundation
import SwiftData

@Model
final class Note {
    @Attribute(.unique) var id: UUID
    var incidentID: UUID
    var text: String
    var createdAt: Date

    init(id: UUID = UUID(), incidentID: UUID, text: String, createdAt: Date = .now) {
        self.id = id
        self.incidentID = incidentID
        self.text = text
        self.createdAt = createdAt
    }
}
