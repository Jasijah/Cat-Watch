import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet.rectangle")
                }

            WatchlistView()
                .tabItem {
                    Label("Watchlist", systemImage: "star")
                }

            ChecklistView()
                .tabItem {
                    Label("Tools", systemImage: "checklist")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(Theme.Colors.redGlow)
    }
}
