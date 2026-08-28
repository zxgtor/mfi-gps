import SwiftUI

@main
struct MFiGPSApp: App {
    @StateObject private var locationMonitor = LocationMonitor()
    @StateObject private var accessoryMonitor = AccessoryMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationMonitor)
                .environmentObject(accessoryMonitor)
        }
    }
}

