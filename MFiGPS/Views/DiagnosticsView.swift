import SwiftUI

struct DiagnosticsView: View {
    @EnvironmentObject private var locationMonitor: LocationMonitor
    @EnvironmentObject private var accessoryMonitor: AccessoryMonitor

    var body: some View {
        NavigationStack {
            List {
                Section("Core Location") {
                    LabeledContent("Authorization", value: String(describing: locationMonitor.authorizationStatus))
                    LabeledContent("Recorded samples", value: "\(locationMonitor.samples.count)")
                    if let error = locationMonitor.errorMessage {
                        Text(error).foregroundStyle(.red)
                    }
                    Button("Clear samples", role: .destructive) {
                        locationMonitor.clearSamples()
                    }
                }

                Section("ExternalAccessory") {
                    LabeledContent("Last event", value: accessoryMonitor.lastEvent)
                    Button("Refresh") { accessoryMonitor.refresh() }
                    if accessoryMonitor.accessories.isEmpty {
                        Text("No accessory is visible through ExternalAccessory.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(accessoryMonitor.accessories) { accessory in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(accessory.name).font(.headline)
                            Text("\(accessory.manufacturer) · \(accessory.modelNumber)")
                            Text(accessory.protocols.joined(separator: ", "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Interpretation") {
                    Text("Core Location does not expose a public source label. Accessory visibility and location changes are recorded as separate evidence and must not be treated as proof by themselves.")
                        .font(.footnote)
                }
            }
            .navigationTitle("Diagnostics")
        }
    }
}

