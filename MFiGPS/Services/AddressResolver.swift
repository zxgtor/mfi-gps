import CoreLocation
import Foundation

enum AddressResolverError: LocalizedError {
    case noResult

    var errorDescription: String? { "No coordinate was found for that address." }
}

struct AddressResolver {
    private let geocoder = CLGeocoder()

    func resolve(_ address: String) async throws -> TargetLocation {
        let placemarks = try await geocoder.geocodeAddressString(address)
        guard let coordinate = placemarks.first?.location?.coordinate else {
            throw AddressResolverError.noResult
        }
        return TargetLocation(
            address: address,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
}

