# Build and first-run instructions

## On iPhone

1. In Working Copy, clone or pull `zxgtor/mfi-gps`.
2. Use Textastic only for reading files; this is a native SwiftUI project and cannot be previewed as a website.
3. Export or copy the complete repository to the Mac.

## On Mac

1. Open `MFiGPS.xcodeproj` in Xcode.
2. Select the `MFiGPS` target, then Signing & Capabilities.
3. Choose your Apple Development team. Change the bundle identifier if Xcode reports a conflict.
4. Connect and trust the iPhone, enable Developer Mode if requested, and select it as the run destination.
5. Build and run.

The checked-in Xcode project requires no package download. `project.yml` is included only as a reproducible XcodeGen description.

## First test

1. Grant When In Use location permission.
2. Enter an address and resolve it.
3. Tap Request Permission and Start.
4. Export `TargetLocation.gpx`.
5. On the Mac, add the GPX file to the Xcode project and select it from Debug > Simulate Location.
6. Verify whether this app and Apple Maps or a second Core Location client report the same target.
7. Record the intended path and second-client checkboxes. A confirmed result requires both.

## External accessory limitation

ExternalAccessory only exposes accessories and protocols that iOS makes available to this application. An empty list does not prove that no external GNSS hardware is connected, and a visible accessory does not prove that iOS selected it as the system location source.
