//
//  TimecodeQuarterFrame.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Common: Timecode Quarter-Frame
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "For device synchronization, MIDI Time Code uses two basic types of messages, described as Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System Exclusive Message."
    public struct TimecodeQuarterFrame: Equatable, Hashable {
        
        /// Data Byte containing quarter-frame bits
        public var dataByte: MIDI.UInt7
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(dataByte: MIDI.UInt7,
                    group: MIDI.UInt4 = 0x0) {
            
            self.dataByte = dataByte
            self.group = group
            
        }
        
    }
    
    /// System Common: Timecode Quarter-Frame
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "For device synchronization, MIDI Time Code uses two basic types of messages, described as Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System Exclusive Message."
    ///
    /// - Parameters:
    ///   - dataByte: Data Byte containing quarter-frame bits
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func timecodeQuarterFrame(dataByte: MIDI.UInt7,
                                            group: MIDI.UInt4 = 0x0) -> Self {
        
        .timecodeQuarterFrame(
            .init(dataByte: dataByte,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.TimecodeQuarterFrame {
    
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF1, dataByte.uInt8Value]
        
    }
    
    @inline(__always)
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF1,
                                dataByte.uInt8Value,
                                0x00) // pad an empty byte to fill 4 bytes
        
        return [word]
        
    }
    
}
