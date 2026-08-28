import ExternalAccessory
import Combine
import Foundation

struct AccessorySnapshot: Identifiable {
    let id: Int
    let name: String
    let manufacturer: String
    let modelNumber: String
    let protocols: [String]

    init(_ accessory: EAAccessory) {
        id = accessory.connectionID
        name = accessory.name
        manufacturer = accessory.manufacturer
        modelNumber = accessory.modelNumber
        protocols = accessory.protocolStrings
    }
}

@MainActor
final class AccessoryMonitor: ObservableObject {
    @Published private(set) var accessories: [AccessorySnapshot] = []
    @Published private(set) var lastEvent = "No accessory event observed"

    init() {
        EAAccessoryManager.shared().registerForLocalNotifications()
        NotificationCenter.default.addObserver(
            forName: .EAAccessoryDidConnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory else { return }
            Task { @MainActor in
                self?.lastEvent = "Connected: \(accessory.name)"
                self?.refresh()
            }
        }
        NotificationCenter.default.addObserver(
            forName: .EAAccessoryDidDisconnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory else { return }
            Task { @MainActor in
                self?.lastEvent = "Disconnected: \(accessory.name)"
                self?.refresh()
            }
        }
        refresh()
    }

    func refresh() {
        accessories = EAAccessoryManager.shared().connectedAccessories.map(AccessorySnapshot.init)
    }
}
