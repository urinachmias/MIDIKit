//
//  OSStatus.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

extension MIDIIOManager {
	
	/// An enumeration representing `CoreMIDI.MIDIServices` `OSStatus` error codes, with verbose descriptions.
	public enum OSStatusResult: Error {
		
		/// `CoreMIDI.kMIDIInvalidClient`:
		/// An invalid `MIDIClientRef` was passed.
		case invalidClient

		/// `CoreMIDI.kMIDIInvalidPort`:
		/// An invalid `MIDIPortRef` was passed.
		case invalidPort

		/// `CoreMIDI.kMIDIWrongEndpointType`:
		/// A source endpoint was passed to a function expecting a destination, or vice versa.
		case wrongEndpointType

		/// `CoreMIDI.kMIDINoConnection`:
		/// Attempt to close a non-existent connection.
		case noConnection

		/// `CoreMIDI.kMIDIUnknownEndpoint`:
		/// An invalid `MIDIEndpointRef` was passed.
		case unknownEndpoint

		/// `CoreMIDI.kMIDIUnknownProperty`:
		/// Attempt to query a property not set on the object.
		case unknownProperty

		/// `CoreMIDI.kMIDIWrongPropertyType`:
		/// Attempt to set a property with a value not of the correct type.
		case wrongPropertyType

		/// `CoreMIDI.kMIDINoCurrentSetup`:
		/// Internal error; there is no current MIDI setup object.
		case noCurrentSetup

		/// `CoreMIDI.kMIDIMessageSendErr`:
		/// Communication with MIDIServer failed.
		case messageSendErr

		/// `CoreMIDI.kMIDIServerStartErr`:
		/// Unable to start MIDIServer.
		case serverStartErr

		/// `CoreMIDI.kMIDISetupFormatErr`:
		/// Unable to read the saved state.
		case setupFormatErr

		/// `CoreMIDI.kMIDIWrongThread`:
		/// A driver is calling a non-I/O function in the server from a thread other than the server's main thread.
		case wrongThread

		/// `CoreMIDI.kMIDIObjectNotFound`:
		/// The requested object does not exist.
		case objectNotFound

		/// `CoreMIDI.kMIDIIDNotUnique`:
		/// Attempt to set a non-unique `kMIDIPropertyUniqueID` on an object.
		case iDNotUnique

		/// `CoreMIDI.kMIDINotPermitted`:
		/// The process does not have privileges for the requested operation.
		case notPermitted

		/// `CoreMIDI.kMIDIUnknownError`:
		/// Internal error; unable to perform the requested operation.
		case unknownError
		
		/// Other `OSStatus`
		case other(Int32)
		
	}
	
}

extension MIDIIOManager.OSStatusResult {
	
	public var rawValue: Int32 {
		
		switch self {
		case .invalidClient: return -10830
		case .invalidPort: return -10831
		case .wrongEndpointType: return -10832
		case .noConnection: return -10833
		case .unknownEndpoint: return -10834
		case .unknownProperty: return -10835
		case .wrongPropertyType: return -10836
		case .noCurrentSetup: return -10837
		case .messageSendErr: return -10838
		case .serverStartErr: return -10839
		case .setupFormatErr: return -10840
		case .wrongThread: return -10841
		case .objectNotFound: return -10842
		case .iDNotUnique: return -10843
		case .notPermitted: return -10844
		case .unknownError: return -10845
		case .other(let val): return val
		}
		
	}
	
	public init(rawValue: Int32) {
		
		switch rawValue {
		case -10830: self = .invalidClient
		case -10831: self = .invalidPort
		case -10832: self = .wrongEndpointType
		case -10833: self = .noConnection
		case -10834: self = .unknownEndpoint
		case -10835: self = .unknownProperty
		case -10836: self = .wrongPropertyType
		case -10837: self = .noCurrentSetup
		case -10838: self = .messageSendErr
		case -10839: self = .serverStartErr
		case -10840: self = .setupFormatErr
		case -10841: self = .wrongThread
		case -10842: self = .objectNotFound
		case -10843: self = .iDNotUnique
		case -10844: self = .notPermitted
		case -10845: self = .unknownError
		default: self = .other(rawValue)
		}
		
	}
	
}

extension MIDIIOManager.OSStatusResult: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
		case .invalidClient:
			return "An invalid MIDIClientRef was passed. kMIDIInvalidClient)"
		case .invalidPort:
			return "An invalid MIDIPortRef was passed. (kMIDIInvalidPort)"
		case .wrongEndpointType:
			return "A source endpoint was passed to a function expecting a destination, or vice versa. (kMIDIWrongEndpointType)"
		case .noConnection:
			return "Attempt to close a non-existent connection. (kMIDINoConnection)"
		case .unknownEndpoint:
			return "An invalid MIDIEndpointRef was passed. (kMIDIUnknownEndpoint)"
		case .unknownProperty:
			return "Attempt to query a property not set on the object. (kMIDIUnknownProperty)"
		case .wrongPropertyType:
			return "Attempt to set a property with a value not of the correct type. (kMIDIWrongPropertyType)"
		case .noCurrentSetup:
			return "Internal error; there is no current MIDI setup object. (kMIDINoCurrentSetup)"
		case .messageSendErr:
			return "Communication with MIDIServer failed. (kMIDIMessageSendErr)"
		case .serverStartErr:
			return "Unable to start MIDIServer. (kMIDIServerStartErr)"
		case .setupFormatErr:
			return "Unable to read the saved state. (kMIDISetupFormatErr)"
		case .wrongThread:
			return "A driver is calling a non-I/O function in the server from a thread other than the server's main thread. (kMIDIWrongThread)"
		case .objectNotFound:
			return "The requested object does not exist. (kMIDIObjectNotFound)"
		case .iDNotUnique:
			return "Attempt to set a non-unique kMIDIPropertyUniqueID on an object. (kMIDIIDNotUnique)"
		case .notPermitted:
			return "The process does not have privileges for the requested operation. (kMIDINotPermitted)"
		case .unknownError:
			return "Internal error; unable to perform the requested operation. (kMIDIUnknownError)"
		case .other(let osStatus):
			return "Unknown OSStatus error: \(osStatus)"
		}
		
	}
	
}
