//
//  Input Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
import MIDIKit
import CoreMIDI

final class InputsAndOutputs_Input_Tests: XCTestCase {
	
    fileprivate var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_Input_Tests",
                        model: "MIDIKit123",
                        manufacturer: "MIDIKit")
	}
	
	override func tearDown() {
		manager = nil
        XCTWait(sec: 0.3)
	}
	
	func testInput() throws {
		
		// start midi client
		
		try manager.start()
		
		XCTWait(sec: 0.1)
		
		// add new endpoint
		
		let tag1 = "1"
		
		do {
			try manager.addInput(
				name: "MIDIKit IO Tests Destination 1",
                tag: tag1,
                uniqueID: .none, // allow system to generate random ID
				receiveHandler: .rawData({ packets in
					_ = packets
				})
			)
		} catch let err as MIDI.IO.MIDIError {
			XCTFail(err.localizedDescription) ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(manager.managedInputs[tag1])
        let id1 = manager.managedInputs[tag1]?.uniqueID
        XCTAssertNotNil(id1)
        
		// unique ID collision
		
		let tag2 = "2"
		
		do {
			try manager.addInput(
				name: "MIDIKit IO Tests Destination 2",
				tag: tag2,
                uniqueID: .preferred(id1!), // try to use existing ID
				receiveHandler: .rawData({ packet in
					_ = packet
				})
			)
		} catch let err as MIDI.IO.MIDIError {
			XCTFail("\(err)") ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(manager.managedInputs[tag2])
        let id2 = manager.managedInputs[tag2]?.uniqueID
        
		// ensure ids are different
		XCTAssertNotEqual(id1, id2)
		
		// remove endpoints
		
		manager.remove(.input, .withTag(tag1))
		XCTAssertNil(manager.managedInputs[tag1])
		
		manager.remove(.input, .withTag(tag2))
		XCTAssertNil(manager.managedInputs[tag2])
		
	}

}

#endif

