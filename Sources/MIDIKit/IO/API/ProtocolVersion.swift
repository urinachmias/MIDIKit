//
//  ProtocolVersion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// MIDI protocol version.
    public enum ProtocolVersion: Equatable, Hashable {
        
        /// MIDI 1.0
        case _1_0
        
        /// MIDI 2.0
        case _2_0
        
    }
    
}

extension MIDI.IO.ProtocolVersion {
    
    /// Initializes from the corresponding Core MIDI `MIDIProtocolID`.
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    @inline(__always)
    internal init(_ coreMIDIProtocol: MIDIProtocolID) {
        
        switch coreMIDIProtocol {
        case ._1_0:
            self = ._1_0
            
        case ._2_0:
            self = ._2_0
            
        @unknown default:
            self = ._2_0
            
        }
        
    }
    
    /// Returns the corresponding Core MIDI `MIDIProtocolID`.
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    @inline(__always)
    internal var coreMIDIProtocol: MIDIProtocolID {
        
        switch self {
        case ._1_0:
            return ._1_0
            
        case ._2_0:
            return ._2_0
            
        }
        
    }
    
}

extension MIDI.IO.ProtocolVersion: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case ._1_0:
            return "MIDI 1.0"
            
        case ._2_0:
            return "MIDI 2.0"
            
        }
        
    }
    
}
