//
//  ContentView.swift
//  DemoApp
//
//  Created by hassan uriostegui on 8/30/22.
//

import SwiftUI
import

struct ContentView: View {
    var videoPlayer:AVPlayer{
        AVPlayerSwiftUI.player(Seed.HomeVideoURL, id: "homeVideo", muted: true, autoplay: true)
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
