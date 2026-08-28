import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let gpx = UTType(exportedAs: "com.topografix.gpx", conformingTo: .xml)
}

struct GPXDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.gpx, .xml] }

    let text: String

    init(target: TargetLocation) {
        let escapedName = target.address
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
        text = """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="MFi GPS Lab" xmlns="http://www.topografix.com/GPX/1/1">
          <wpt lat="\(target.latitude)" lon="\(target.longitude)">
            <name>\(escapedName)</name>
          </wpt>
        </gpx>
        """
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let text = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.text = text
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}

