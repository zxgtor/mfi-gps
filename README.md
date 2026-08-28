# MFi GPS System Location Lab

An experimental iOS project for determining when iOS accepts an external location source and whether that source affects the system location seen by other apps.

## Primary goal

The target is **system location**, not an app-only mock:

- Apple Maps and other Core Location clients should observe the same externally supplied position.
- The project must distinguish a real system-level result from a location value simulated only inside this app.
- The first release is a feasibility and diagnostics release. It will not claim system-location control unless cross-app verification proves it.

## Important platform boundary

A normal App Store iOS application cannot replace the system Core Location provider through a public API. Candidate system-level paths therefore need separate testing:

1. An iOS-supported external GNSS/MFi accessory.
2. Xcode location simulation as a development control.
3. CarPlay/vehicle integration where supported by Apple and the accessory.
4. Private APIs or jailbreaking are out of scope.

## Version 0.1 scope

- Document each candidate path and its requirements.
- Record Core Location output with timestamps and quality metrics.
- Observe accessory connect/disconnect events where public APIs allow it.
- Compare the requested test address with the system-reported position.
- Verify results independently in this app and a second system app such as Apple Maps.
- Produce evidence with confidence levels instead of guessing the hidden source selected by iOS.

See:

- [Feasibility and source model](docs/FEASIBILITY.md)
- [Test plan](docs/TEST_PLAN.md)
- [Address test page specification](docs/ADDRESS_TEST.md)

## Success criterion

A test passes only when the target position is delivered through the intended external path and is independently observed by multiple Core Location clients. Merely moving a marker inside this app is not a pass.
