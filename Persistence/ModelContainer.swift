import Foundation
import SwiftData

enum AppModelContainer {
    static func make(inMemory: Bool = false) -> ModelContainer {
        let schema = Schema([
            Incident.self,
            Zone.self,
            AlertRule.self,
            ChecklistItem.self,
            Note.self
        ])

        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
}
