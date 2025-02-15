//
//  ThruConnection Lifecycle.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.IO.ThruConnection {
    
    /// ThruConnection lifecycle type.
    public enum Lifecycle: Hashable {
        
        /// The play-through connection exists as long as the `Manager` exists.
        case nonPersistent
        
        /// The play-through connection is stored in the system and persists indefinitely (even after system reboots) until explicitly removed.
        ///
        /// - `ownerID`: Reverse-DNS domain string; usually the application's bundle ID.
        case persistent(ownerID: String)
        
    }
    
}

extension MIDI.IO.ThruConnection.Lifecycle: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .nonPersistent:
            return "nonPersistent"
            
        case .persistent(let ownerID):
            return "persistent(\(ownerID)"
        }
        
    }
    
}
