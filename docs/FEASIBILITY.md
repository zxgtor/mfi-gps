# Feasibility and source-inference model

## What iOS publicly exposes

Core Location provides position observations such as coordinate, horizontal/vertical accuracy, altitude, speed, course, timestamp, and authorization state. It does **not** provide a reliable public field saying “internal GPS”, “MFi GPS”, “CarPlay”, “Wi-Fi”, or “cellular”.

ExternalAccessory can report accessories and protocol sessions when the manufacturer exposes an MFi protocol to the app. Seeing an accessory does not by itself prove that iOS selected it as the system location source.

## Candidate paths

| Path | Can a normal app request it? | Can it affect system location? | First-release treatment |
|---|---:|---:|---|
| Core Location API | Read only | No override API | Record observations |
| App-only mock provider | Yes | No | Explicitly excluded as success |
| Xcode GPX simulation | From a development Mac | Yes, during controlled debugging | Positive control |
| Supported external MFi/GNSS accessory | Hardware/firmware dependent | Potentially, if integrated by iOS | Primary research path |
| CarPlay vehicle location integration | Entitlement/accessory dependent | Potentially used internally by iOS | Separate test path |
| Browser geolocation | Read only | No | Not a control path |
| Private API/jailbreak | Unsupported | Possibly | Out of scope |

## Confidence-based inference

Because iOS hides the selected source, version 0.1 uses evidence rather than a false definitive label.

### Evidence collected

- System coordinate and timestamp sequence
- Horizontal and vertical accuracy
- Altitude, speed, course, and update frequency
- Accessory connection/disconnection timestamps
- Test target coordinate and distance error
- Apple Maps or a second Core Location client result
- Test environment: outdoors, indoors, shielded, moving, stationary
- Xcode debug simulation state, when used

### Confidence output

- **Confirmed system-level**: two independent Core Location clients follow the target while the intended external path is active, and stop or change predictably when it is removed.
- **Strongly correlated**: Core Location changes with accessory state, but independent cross-app verification is incomplete.
- **Inconclusive**: observations can also be explained by internal GNSS, Wi-Fi, cached location, or Xcode simulation.
- **Rejected**: only the app UI changes; other Core Location clients do not.

This is an observational model, not an unsupported claim that iOS reveals its internal priority.
