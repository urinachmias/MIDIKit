//
//  Manager Add and Remove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Adds a new managed virtual input to the `managedInputs` dictionary of the `Manager` and creates the MIDI port in the system.
    ///
    /// The lifecycle of the MIDI port exists for as long as the `Manager` instance exists, or until `.remove(::)` is called.
    ///
    /// A note on `uniqueID`:
    ///
    /// It is best practise that the `uniqueID` be stored persistently in a data store of your choosing, and supplied when recreating the same port. This allows other applications to identify the port and reconnect to it, as the port name is not used to identify a MIDI port since MIDI ports are allowed to have the same name, but must have unique IDs.
    ///
    /// It is best practise to re-store the `uniqueID` every time this method is called, since these IDs are temporal and not registered or permanently reserved in the system. Since ID collisions are possible, a new available random ID will be obtained and used if that happens, and that updated ID should be stored in-place of the old one in your data store.
    ///
    /// Do not generate the ID number yourself - it is always system-generated and then we should store and persist it. `UniqueIDPersistence` offers mechanisms to simplify this.
    ///
    /// - Parameters:
    ///   - name: Name of the endpoint as seen in the system.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - uniqueID: System-global unique identifier for the port.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addInput(
        name: String,
        tag: String,
        uniqueID: MIDI.IO.UniqueIDPersistence<MIDI.IO.InputEndpoint.UniqueID>,
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try eventQueue.sync {
            
            let newVD = MIDI.IO.Input(
                name: name,
                uniqueID: uniqueID.readID(),
                receiveHandler: receiveHandler,
                midiManager: self,
                api: preferredAPI
            )
            
            managedInputs[tag] = newVD
            
            try newVD.create(in: self)
            
            guard let successfulID = newVD.uniqueID else {
                throw MIDI.IO.MIDIError.connectionError(
                    "Could not read virtual MIDI endpoint unique ID."
                )
            }
            
            uniqueID.writeID(successfulID)
            
        }
        
    }
    
    /// Adds a new managed connected input to the `managedInputConnections` dictionary of the `Manager`.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addInputConnection(
        toOutputs: [MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint>],
        tag: String,
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try eventQueue.sync {
            
            let newCD = MIDI.IO.InputConnection(
                toOutputs: toOutputs,
                receiveHandler: receiveHandler,
                midiManager: self,
                api: preferredAPI
            )
            
            // store the connection object in the manager,
            // even if subsequent connection fails
            managedInputConnections[tag] = newCD
            
            try newCD.listen(in: self)
            try newCD.connect(in: self)
            
        }
        
    }
    
    /// Adds new a managed virtual output to the `managedOutputs` dictionary of the `Manager`.
    ///
    /// The lifecycle of the MIDI port exists for as long as the `Manager` instance exists, or until `.remove(::)` is called.
    ///
    /// A note on `uniqueID`:
    ///
    /// It is best practise that the `uniqueID` be stored persistently in a data store of your choosing, and supplied when recreating the same port. This allows other applications to identify the port and reconnect to it, as the port name is not used to identify a MIDI port since MIDI ports are allowed to have the same name, but must have unique IDs.
    ///
    /// It is best practise to re-store the `uniqueID` every time this method is called, since these IDs are temporal and not registered or permanently reserved in the system. Since ID collisions are possible, a new available random ID will be obtained and used if that happens, and that updated ID should be stored in-place of the old one in your data store.
    ///
    /// Do not generate the ID number yourself - it is always system-generated and then we should store and persist it. `UniqueIDPersistence` offers mechanisms to simplify this.
    ///
    /// - Parameters:
    ///   - name: Name of the endpoint as seen in the system.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - uniqueID: System-global unique identifier for the port.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addOutput(
        name: String,
        tag: String,
        uniqueID: MIDI.IO.UniqueIDPersistence<MIDI.IO.OutputEndpoint.UniqueID>
    ) throws {
        
        try eventQueue.sync {
            
            let newVS = MIDI.IO.Output(
                name: name,
                uniqueID: uniqueID.readID(),
                midiManager: self,
                api: preferredAPI
            )
            
            managedOutputs[tag] = newVS
            
            try newVS.create(in: self)
            
            guard let successfulID = newVS.uniqueID else {
                throw MIDI.IO.MIDIError.connectionError(
                    "Could not read virtual MIDI endpoint unique ID."
                )
            }
            
            uniqueID.writeID(successfulID)
            
        }
        
    }
    
    /// Adds a new managed connected output to the `managedOutputConnections` dictionary of the `Manager`.
    ///
    /// - Parameters:
    ///   - toInputs: Criteria for identifying a MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addOutputConnection(
        toInputs: [MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>],
        tag: String
    ) throws {
        
        try eventQueue.sync {
            
            let newCS = MIDI.IO.OutputConnection(
                toInputs: toInputs,
                midiManager: self,
                api: preferredAPI
            )
            
            // store the connection object in the manager,
            // even if subsequent operations fail
            managedOutputConnections[tag] = newCS
            
            try newCS.setupOutput(in: self)
            try newCS.resolveEndpoints(in: self)
            
        }
        
    }
    
    /// Creates a new MIDI play-through (thru) connection.
    ///
    /// If the connection is non-persistent, a managed thru connection will be added to the `managedThruConnections` dictionary of the `Manager` and its lifecycle will be that of the `Manager` or until removeThruConnection is called for the connection.
    ///
    /// If the connection is persistent, it is instead stored persistently by the system and references will not be directly held in the `Manager`. To access persistent connections, the `unmanagedPersistentThruConnections` property will retrieve a list of connections from the system, if any match the owner ID passed as argument.
    ///
    /// For every persistent thru connection your app creates, they should be assigned the same persistent ID (domain) so they can be managed or removed in future.
    ///
    /// - Warning: Be careful when creating persistent thru connections, as they can become stale and orphaned if the endpoints used to create them cease to be relevant at any point in time.
    ///
    /// - Note: Max 8 outputs and max 8 inputs are allowed when forming a thru connection.
    ///
    /// - Parameters:
    ///   - outputs: Maximum of 8 `Endpoint`s.
    ///   - inputs: Maximum of 8 `Endpoint`s.
    ///   - tag: Unique `String` key to refer to the new object that gets added to `managedThruConnections` collection dictionary.
    ///   - lifecycle: If `false`, thru connection will expire when the app terminates. If `true`, the connection persists in the system indefinitely (even after system reboots) until explicitly removed.
    ///   - params: Optionally define custom `MIDIThruConnectionParams`.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addThruConnection(
        outputs: [MIDI.IO.OutputEndpoint],
        inputs: [MIDI.IO.InputEndpoint],
        tag: String,
        lifecycle: MIDI.IO.ThruConnection.Lifecycle = .nonPersistent,
        params: MIDI.IO.ThruConnection.Parameters = .init()
    ) throws {
        
        try eventQueue.sync {
            
            let newCT = MIDI.IO.ThruConnection(
                outputs: outputs,
                inputs: inputs,
                lifecycle: lifecycle,
                params: params,
                midiManager: self,
                api: preferredAPI
            )
            
            // if non-persistent, add to managed array
            if lifecycle == .nonPersistent {
                // store the connection object in the manager,
                // even if subsequent connection fails
                managedThruConnections[tag] = newCT
            }
            
            // otherwise, we won't store a reference to a persistent thru connection
            // persistent connections are stored by the system
            // to analyze or delete a persistent connection,
            // access the `unmanagedPersistentThruConnections(ownerID:)` method.
            
            try newCT.create(in: self)
            
        }
        
    }
    
}

extension MIDI.IO.Manager {
    
    public enum ManagedType: CaseIterable, Hashable {
        case inputConnection
        case outputConnection
        case nonPersistentThruConnection
        case input
        case output
    }
    
    public enum TagSelection: Hashable {
        case all
        case withTag(String)
    }
    
    // individual methods
    
    /// Remove a managed MIDI endpoint or connection.
    public func remove(_ type: ManagedType,
                       _ tagSelection: TagSelection) {
        
        eventQueue.sync {
            
            switch type {
            case .inputConnection:
                switch tagSelection {
                case .all:
                    managedInputConnections.removeAll()
                case .withTag(let tag):
                    managedInputConnections[tag] = nil
                }
                
            case .outputConnection:
                switch tagSelection {
                case .all:
                    managedOutputConnections.removeAll()
                case .withTag(let tag):
                    managedOutputConnections[tag] = nil
                }
                
            case .nonPersistentThruConnection:
                switch tagSelection {
                case .all:
                    managedThruConnections.removeAll()
                case .withTag(let tag):
                    managedThruConnections[tag] = nil
                }
                
            case .input:
                switch tagSelection {
                case .all:
                    managedInputs.removeAll()
                case .withTag(let tag):
                    managedInputs[tag] = nil
                }
                
            case .output:
                switch tagSelection {
                case .all:
                    managedOutputs.removeAll()
                case .withTag(let tag):
                    managedOutputs[tag] = nil
                }
                
            }
            
        }
        
    }
    
    /// Remove all managed MIDI endpoints and connections.
    ///
    /// What is unaffected, and not reset:
    /// - Persistent thru connections stored in the system.
    /// - Notification handler attached to the `Manager`.
    /// - `clientName` property
    /// - `model` property
    /// - `manufacturer` property
    public func removeAll() {
        
        // `self.remove(...)` internally uses operationQueue.sync{}
        // so don't need to wrap this with it here
        
        for managedEndpointType in ManagedType.allCases {
            remove(managedEndpointType, .all)
        }
        
    }
    
}


