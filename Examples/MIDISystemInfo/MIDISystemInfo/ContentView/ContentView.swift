//
//  ContentView.swift
//  MIDISystemInfo
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit
import OTCore

struct ContentView: View {
    
    // if you declare a view that creates its own @ObservedObject instance, that instance is replaced every time SwiftUI decides that it needs to discard and redraw that view.
    // it should instead be used to retain a weak reference from the view's initializer, with the original instance of the object stored in a parent scope as either a var or @StateObject but not an @ObservedObject
    
    @ObservedObject var midiManager: MIDI.IO.Manager
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                Section(header: Text("MIDI Devices")) {
                    
                    ForEach(midiManager.devices.devices.sortedByName()) { item in
                        let detailsView = DetailsView(object: item.asAnyMIDIIOObject())
                        
                        NavigationLink(destination: detailsView) {
                            Group {
                                if let nsImg = item.getImageAsNSImage() {
                                    Image(nsImage: nsImg)
                                        .resizable()
                                } else {
                                    Text("🎹")
                                }
                            }
                            .frame(width: 18, height: 18, alignment: .center)
                            
                            Text("\(item.name)")
                        }
                    }
                    
                }
                
                Section(header: Text("MIDI Output Endpoints")) {
                    
                    ForEach(midiManager.endpoints.outputs.sortedByName()) { item in
                        let detailsView = DetailsView(object: item.asAnyMIDIIOObject())
                        
                        NavigationLink(destination: detailsView) {
                            Group {
                                if let nsImg = item.getImageAsNSImage() {
                                    Image(nsImage: nsImg)
                                        .resizable()
                                } else {
                                    Text("🎵")
                                }
                            }
                            .frame(width: 18, height: 18, alignment: .center)
                            
                            Text("\(item.name)")
                        }
                    }
                    
                }
                
                Section(header: Text("MIDI Input Endpoints")) {
                    
                    ForEach(midiManager.endpoints.inputs.sortedByName()) { item in
                        let detailsView = DetailsView(object: item.asAnyMIDIIOObject())
                        
                        NavigationLink(destination: detailsView) {
                            Group {
                                if let nsImg = item.getImageAsNSImage() {
                                    Image(nsImage: nsImg)
                                        .resizable()
                                } else {
                                    Text("🎵")
                                }
                            }
                            .frame(width: 18, height: 18, alignment: .center)
                            
                            Text("\(item.name)")
                        }
                    }
                    
                }
                
            }
            .frame(width: 300)
            
            EmptyDetailsView()
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
}

struct ContentViewCatalina_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(midiManager: .init(clientName: "Preview", model: "", manufacturer: ""))
    }
}
