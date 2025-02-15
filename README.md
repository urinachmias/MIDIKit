# 🎹 MIDIKit

[![CI Build Status](https://github.com/orchetect/MIDIKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/MIDIKit/actions/workflows/build.yml) [![Platforms - macOS 10.12+ | iOS 10+ (beta)](https://img.shields.io/badge/platforms-macOS%2010.12%2B%20|%20iOS%2010%2B-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/MIDIKit/blob/main/LICENSE)

An elegant and modern Swift CoreMIDI wrapper supporting MIDI 1.0 and MIDI 2.0.

- Modular, user-friendly I/O
- Automatic MIDI endpoint connection management and unique ID persistence
- Strongly-typed MIDI events that seamlessly interoperate between MIDI 1.0 and MIDI 2.0
- Automatically uses appropriate Core MIDI API and defaults to MIDI 2.0 on platforms that support them

## MIDIKit Extensions

Abstractions are built as optional extensions in their own repos.

- [MIDIKitControlSurfaces](https://github.com/orchetect/MIDIKitControlSurfaces): MIDIKit extension for Control Surfaces (HUI, etc.)
- [MIDIKitSync](https://github.com/orchetect/MIDIKitSync): MIDIKit extension for sync (MTC, etc.)
- [MIDIKitSMF](https://github.com/orchetect/MIDIKitSMF): MIDIKit extension for reading/writing Standard MIDI Files (SMF)

## Getting Started

1. Add MIDIKit as a dependency  using Swift Package Manager.
   - In an app project or framework, in Xcode:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/MIDIKit`
   
   - In a Swift Package, add it to the Package.swift dependencies:
     ```swift
     .package(url: "https://github.com/orchetect/MIDIKit", from: "0.3.0")
     ```
  
1. Import the library:
  ```swift
  import MIDIKit
  ```

3. See [Examples](https://github.com/orchetect/MIDIKit/blob/master/Examples/) folder and [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder for usage.

## Documentation

See [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder.

Also see project [Examples](https://github.com/orchetect/MIDIKit/blob/master/Examples/) folder.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MIDIKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Discussion in Issues is encouraged prior to new features or modifications.
