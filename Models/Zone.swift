import Foundation
import SwiftData

@Model
final class Zone {
    @Attribute(.unique) var id: UUID
    var name: String
    var centerLatitude: Double
    var centerLongitude: Double
    var radiusKM: Double

    init(id: UUID = UUID(), name: String, centerLatitude: Double, centerLongitude: Double, radiusKM: Double) {
        self.id = id
        self.name = name
        self.centerLatitude = centerLatitude
        self.centerLongitude = centerLongitude
        self.radiusKM = radiusKM
    }
}
