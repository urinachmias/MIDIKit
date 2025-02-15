//
//  UniqueID Persistence.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.IO {
    
    /// Defines persistence behavior of a MIDI unique ID in the system.
    public enum UniqueIDPersistence<T: MIDIIOUniqueIDProtocol> {
        
        /// The unique ID will be randomly generated every time it is created in the system.
        case none
        
        /// Provide a preferred MIDI endpoint unique ID value, without attaching any persistent storage mechanism.
        ///
        /// In the event a collision with an existing unique ID in the system, a new random ID will be generated until there are no collisions.
        case preferred(T)
        
        /// The MIDI endpoint's unique ID is managed automatically and persistently stored in `UserDefaults`.
        ///
        /// If a unique ID does not yet exist for this object, one will be generated randomly.
        ///
        /// In the event a collision with an existing MIDI endpoint unique ID in the system, a new random ID will be generated until there are no collisions.
        /// The ID will then be cached in `UserDefaults` using the key string provided - if the key exists, it will be overwritten.
        case userDefaultsManaged(key: String)
        
        /// Supply handlers to facilitate reading and storing the MIDI endpoint's unique ID.
        ///
        /// This is useful if you need more control over where you want to persist this information.
        ///
        /// In the event a collision with an existing MIDI endpoint unique ID in the system, a new random ID will be generated until there are no collisions.
        /// The ID will then be passed into the `storeHandler` closure in order to store the updated ID.
        case manualStorage(readHandler: () -> MIDI.IO.CoreMIDIUniqueID?,
                           storeHandler: (MIDI.IO.CoreMIDIUniqueID?) -> ())
        
    }
    
}

// MARK: - Read/Write Methods

extension MIDI.IO.UniqueIDPersistence {
    
    /// Reads the unique ID from the persistent storage, if applicable.
    public func readID() -> T? {
        
        switch self {
        case .none:
            return nil
            
        case .preferred(uniqueID: let uniqueID):
            return uniqueID
            
        case .userDefaultsManaged(key: let key):
            // test to see if key does not exist first
            // otherwise just calling integer(forKey:) returns 0 if key does not exist
            guard UserDefaults.standard.object(forKey: key) != nil
            else { return nil }
            
            let readInt = UserDefaults.standard.integer(forKey: key)
            
            guard let int32Exactly = Int32(exactly: readInt)
            else { return nil }
            
            return T(int32Exactly)
            
        case .manualStorage(readHandler: let readHandler, storeHandler: _):
            if let readInt = readHandler() {
                return T(readInt)
            }
            
            return nil
            
        }
        
    }
    
    /// Writes the unique ID to the persistent storage, if applicable.
    public func writeID(_ newValue: T?) {
        
        switch self {
        case .none:
            return // no storage
        
        case .preferred(uniqueID: _):
            return // no storage
        
        case .userDefaultsManaged(key: let key):
            UserDefaults.standard.setValue(newValue?.coreMIDIUniqueID, forKey: key)
            
        case .manualStorage(readHandler: _, storeHandler: let storeHandler):
            storeHandler(newValue?.coreMIDIUniqueID)
            
        }
        
    }
    
}
