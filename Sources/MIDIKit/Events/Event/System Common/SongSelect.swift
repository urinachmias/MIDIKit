//
//  SongSelect.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Common: Song Select
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Specifies which song or sequence is to be played upon receipt of a Start message in sequencers and drum machines capable of holding multiple songs or sequences. This message should be ignored if the receiver is not set to respond to incoming Real Time messages (MIDI Sync)."
    public struct SongSelect: Equatable, Hashable {
        
        /// Song Number
        public var number: MIDI.UInt7
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(number: MIDI.UInt7,
                    group: MIDI.UInt4 = 0x0) {
            
            self.number = number
            self.group = group
            
        }
        
    }
    
    /// System Common: Song Select
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Specifies which song or sequence is to be played upon receipt of a Start message in sequencers and drum machines capable of holding multiple songs or sequences. This message should be ignored if the receiver is not set to respond to incoming Real Time messages (MIDI Sync)."
    ///
    /// - Parameters:
    ///   - number: Song Number
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func songSelect(number: MIDI.UInt7,
                                  group: MIDI.UInt4 = 0x0) -> Self {
        
        .songSelect(
            .init(number: number,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.SongSelect {
    
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF3, number.uInt8Value]
        
    }
    
    @inline(__always)
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF3,
                                number.uInt8Value,
                                0x00) // pad an empty byte to fill 4 bytes
        
        return [word]
        
    }
    
}
