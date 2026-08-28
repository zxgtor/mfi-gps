# Address-driven test page

## Purpose

The address page defines a target for a **system-location experiment**. It must not silently replace the app's own marker and call that success.

## Inputs

- Street address or place name
- Optional latitude and longitude override
- Allowed error radius in metres
- Test-path selection: Xcode GPX, MFi/GNSS accessory, or CarPlay
- Notes and test identifier

## Outputs

- Resolved coordinate
- Current system coordinate
- Distance from current system location to target
- Accuracy and timestamp
- Accessory connection state when observable
- Cross-app verification checklist
- Confidence result

## Version 0.1 behavior

1. Resolve the entered address to a coordinate.
2. Save it as the experiment target.
3. Display live Core Location observations without altering them.
4. For the Xcode control path, generate GPX content for the target so it can be loaded from Xcode on the Mac.
5. For the external-accessory path, wait for the actual system location to move toward the target and collect evidence.
6. Require the tester to record whether Apple Maps or the second observer shows the same location.

## Explicit non-goal

The address field itself does not have permission to set iOS system location. It drives the test and can generate the Xcode control input; the actual system-level source must be Xcode debugging or a supported hardware/integration path.
