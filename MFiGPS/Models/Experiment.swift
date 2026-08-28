import CoreLocation
import Foundation

enum TestPath: String, CaseIterable, Identifiable, Codable {
    case xcodeGPX = "Xcode GPX"
    case mfiGNSS = "MFi / External GNSS"
    case carPlay = "CarPlay"

    var id: Self { self }
}

enum ConfidenceLevel: String, Codable {
    case confirmed = "Confirmed system-level"
    case strong = "Strongly correlated"
    case inconclusive = "Inconclusive"
    case rejected = "Rejected"
}

struct TargetLocation: Codable, Equatable {
    let address: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LocationSample: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    let horizontalAccuracy: Double
    let verticalAccuracy: Double
    let altitude: Double
    let speed: Double
    let course: Double

    init(_ location: CLLocation) {
        id = UUID()
        timestamp = location.timestamp
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        horizontalAccuracy = location.horizontalAccuracy
        verticalAccuracy = location.verticalAccuracy
        altitude = location.altitude
        speed = location.speed
        course = location.course
    }
}

struct ConfidenceEvaluator {
    static func evaluate(
        distanceToTarget: CLLocationDistance?,
        tolerance: CLLocationDistance,
        intendedPathActive: Bool,
        secondClientVerified: Bool,
        appOnlyMarkerChanged: Bool = false
    ) -> ConfidenceLevel {
        if appOnlyMarkerChanged { return .rejected }
        guard let distanceToTarget, distanceToTarget <= tolerance else {
            return .inconclusive
        }
        if intendedPathActive && secondClientVerified { return .confirmed }
        if intendedPathActive { return .strong }
        return .inconclusive
    }
}

