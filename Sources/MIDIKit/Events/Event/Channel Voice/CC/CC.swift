//
//  CC.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Control Change (CC)
    /// (MIDI 1.0 / 2.0)
    public struct CC: Equatable, Hashable {
        
        /// Controller
        public var controller: Controller
        
        /// Value
        @ValueValidated
        public var value: Value
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(controller: Controller,
                    value: Value,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.controller = controller
            self.value = value
            self.channel = channel
            self.group = group
            
        }
        
        public init(controller: MIDI.UInt7,
                    value: Value,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.controller = .init(number: controller)
            self.value = value
            self.channel = channel
            self.group = group
            
        }
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Control Change (CC)
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - controller: Controller type
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func cc(_ controller: CC.Controller,
                          value: CC.Value,
                          channel: MIDI.UInt4,
                          group: MIDI.UInt4 = 0x0) -> Self {
        
        .cc(
            .init(controller: controller,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Control Change (CC)
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - controller: Controller number
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func cc(_ controller: MIDI.UInt7,
                          value: CC.Value,
                          channel: MIDI.UInt4,
                          group: MIDI.UInt4 = 0x0) -> Self {
        
        .cc(
            .init(controller: controller,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.CC {
    
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xB0 + channel.uInt8Value,
         controller.number.uInt8Value,
         value.midi1Value.uInt8Value]
        
    }
    
    @inline(__always)
    private func umpMessageType(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> MIDI.Packet.UniversalPacketData.MessageType {
        
        switch midiProtocol {
        case ._1_0:
            return .midi1ChannelVoice
            
        case ._2_0:
            return .midi2ChannelVoice
        }
        
    }
    
    @inline(__always)
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
        
        switch midiProtocol {
        case ._1_0:
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xB0 + channel.uInt8Value,
                                    controller.number.uInt8Value,
                                    value.midi1Value.uInt8Value)
            
            return [word]
            
        case ._2_0:
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     0xB0 + channel.uInt8Value,
                                     controller.number.uInt8Value,
                                     0x00) // reserved
            
            let word2 = value.midi2Value
            
            return [word1, word2]
            
        }
        
    }
    
}
