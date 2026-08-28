# System-location test plan

## Required controls

1. **Baseline** — no external accessory, normal Core Location.
2. **Xcode simulation** — known GPX target, used to prove the measurement and cross-app procedure.
3. **Accessory disconnected** — repeat the same environment immediately after disconnect.
4. **Accessory connected** — repeat with the candidate MFi/GNSS accessory.
5. **Independent observer** — verify in Apple Maps or a second minimal Core Location app.

## Test matrix

| Test | Environment | Intended source | Expected evidence |
|---|---|---|---|
| B1 | Outdoors | Internal GNSS | Stable real coordinate |
| B2 | Indoors | Wi-Fi/cached/fused | Lower or variable accuracy |
| X1 | Xcode debug session | GPX target | This app follows target |
| X2 | Xcode debug session | GPX target | Second Core Location client follows target |
| A1 | Same fixed location | Accessory connected | Observation changes with connection |
| A2 | Same fixed location | Accessory disconnected | Observation reverts or degrades |
| A3 | Controlled movement | Accessory connected | Speed/course/update cadence correlate |
| C1 | CarPlay connected | Vehicle integration | Cross-app system output recorded |
| C2 | CarPlay disconnected | Internal/fused | Controlled comparison |

## Pass rule

A system-location claim requires:

- The reported coordinate is within the configured tolerance of the target.
- At least two independent Core Location clients observe it.
- The change correlates with enabling/disabling the intended path.
- The result is repeatable.
- Xcode simulation is recorded separately and cannot be mistaken for MFi evidence.

## Logs

Each run records:

- Test ID and notes
- UTC start/end time
- Target address and resolved coordinate
- Full location sample stream
- Accessory events
- App lifecycle events
- Distance-to-target calculation
- Cross-app verification result
- Final confidence classification
