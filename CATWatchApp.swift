import SwiftUI
import SwiftData

@main
struct CATWatchApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState.repository)
        }
        .modelContainer(appState.modelContainer)
    }
}

@MainActor
final class AppState: ObservableObject {
    let modelContainer: ModelContainer
    let repository: IncidentRepository

    init() {
        self.modelContainer = AppModelContainer.make()
        self.repository = IncidentRepository(
            loader: MockDataLoader(),
            context: ModelContext(modelContainer)
        )
    }
}
