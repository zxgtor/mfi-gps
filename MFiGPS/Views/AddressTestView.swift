import CoreLocation
import SwiftUI

struct AddressTestView: View {
    @EnvironmentObject private var locationMonitor: LocationMonitor
    @EnvironmentObject private var accessoryMonitor: AccessoryMonitor

    @State private var address = ""
    @State private var tolerance = 100.0
    @State private var selectedPath = TestPath.xcodeGPX
    @State private var target: TargetLocation?
    @State private var resolverMessage: String?
    @State private var isResolving = false
    @State private var intendedPathActive = false
    @State private var secondClientVerified = false
    @State private var showingExporter = false

    private var distance: CLLocationDistance? {
        guard let target, let current = locationMonitor.currentLocation else { return nil }
        return current.distance(from: CLLocation(
            latitude: target.latitude,
            longitude: target.longitude
        ))
    }

    private var confidence: ConfidenceLevel {
        ConfidenceEvaluator.evaluate(
            distanceToTarget: distance,
            tolerance: tolerance,
            intendedPathActive: intendedPathActive,
            secondClientVerified: secondClientVerified
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Target") {
                    TextField("Street address or place", text: $address, axis: .vertical)
                        .textInputAutocapitalization(.words)
                    Picker("Test path", selection: $selectedPath) {
                        ForEach(TestPath.allCases) { Text($0.rawValue).tag($0) }
                    }
                    HStack {
                        Text("Tolerance")
                        Slider(value: $tolerance, in: 5...1_000, step: 5)
                        Text("\(Int(tolerance)) m")
                            .monospacedDigit()
                    }
                    Button(isResolving ? "Resolving…" : "Resolve Address") {
                        resolveAddress()
                    }
                    .disabled(address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isResolving)

                    if let resolverMessage {
                        Text(resolverMessage).foregroundStyle(.secondary)
                    }
                    if let target {
                        LabeledContent("Target latitude", value: target.latitude.formatted(.number.precision(.fractionLength(6))))
                        LabeledContent("Target longitude", value: target.longitude.formatted(.number.precision(.fractionLength(6))))
                        Button("Export Xcode GPX") { showingExporter = true }
                    }
                }

                Section("Live system location") {
                    Button("Request Permission and Start") {
                        locationMonitor.requestPermissionAndStart()
                    }
                    if let location = locationMonitor.currentLocation {
                        LabeledContent("Latitude", value: location.coordinate.latitude.formatted(.number.precision(.fractionLength(6))))
                        LabeledContent("Longitude", value: location.coordinate.longitude.formatted(.number.precision(.fractionLength(6))))
                        LabeledContent("Accuracy", value: "\(Int(location.horizontalAccuracy.rounded())) m")
                        if let distance {
                            LabeledContent(
                                "Distance to target",
                                value: Measurement(value: distance, unit: UnitLength.meters)
                                    .formatted(.measurement(width: .abbreviated, usage: .road))
                            )
                        }
                    } else {
                        Text("Waiting for Core Location…").foregroundStyle(.secondary)
                    }
                }

                Section("System-level evidence") {
                    Toggle("Intended path is active", isOn: $intendedPathActive)
                    Toggle("Verified in Apple Maps / second client", isOn: $secondClientVerified)
                    LabeledContent("Visible accessories", value: "\(accessoryMonitor.accessories.count)")
                    LabeledContent("Classification", value: confidence.rawValue)
                    Text("The address field never changes the app marker. A confirmed result requires the real Core Location stream to reach the target and a second client to agree.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("MFi GPS Lab")
            .fileExporter(
                isPresented: $showingExporter,
                document: target.map { GPXDocument(target: $0) },
                contentType: .gpx,
                defaultFilename: "TargetLocation.gpx"
            ) { result in
                if case let .failure(error) = result {
                    resolverMessage = error.localizedDescription
                }
            }
        }
    }

    private func resolveAddress() {
        isResolving = true
        resolverMessage = nil
        Task {
            do {
                target = try await AddressResolver().resolve(address)
                resolverMessage = "Address resolved. This sets the experiment target only."
            } catch {
                resolverMessage = error.localizedDescription
            }
            isResolving = false
        }
    }
}
