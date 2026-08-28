import CoreLocation
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AddressTestView()
                .tabItem { Label("Address Test", systemImage: "mappin.and.ellipse") }
            DiagnosticsView()
                .tabItem { Label("Diagnostics", systemImage: "waveform.path.ecg") }
        }
    }
}

