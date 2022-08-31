//
//  ContentView.swift
//  DemoApp
//
//  Created by hassan uriostegui on 8/30/22.
//

import SwiftUI
import SUIPlayer
import AVFoundation

struct ContentView: View {
    
    /// The Controls struct works as a disposable  connector that allows to fetch the correspoding player
    /// and interface with the inner control status
    /// In itself the controls are not observable intentionally as we want to modularize the updates observation
    /// instead, the controls can be binded to observable states as required
    /// - if a player is meant to be diposed then we should use `.id(playbackId)` to ensure the view will be redrawn when a new player is created
    /// 
    @State var isReady:Bool = false
    @State var isPlaying = false
    @State var isMuted = false
    @State var videoPos = 0.0
    @State var videoDuration = 0.0
    @State var seeking = false
    @State var playbackId = ""
    var controls: SUIPlayer.Controls {
        SUIPlayer.Controls(
            id: playerId,
            url: videoURL,
            isReady: $isReady,
            isPlaying: $isPlaying,
            videoPos: $videoPos,
            videoDuration: $videoDuration,
            seeking: $seeking,
            playbackId: $playbackId
        )
    }
    
    var body: some View {
        VStack{
            
            SUIPlayer.View(controls: controls)
                .id(playbackId)
                .onAppear {
                    controls.play()
                }
                .onDisappear {
                    controls.pause()
                }
                .overlay(
                    VStack{
                       
                        Button(action: controls.pause){
                            Text("Pause")
                        }
                        .buttonStyle(BorderedButtonStyle())
                        
                        
                        Button(action: controls.play ){
                            Text("Play")
                        }
                        .buttonStyle(BorderedButtonStyle())
                        
                        
                        Button(action: controls.dispose){
                            Text("Dispose")
                        }
                        .buttonStyle(BorderedButtonStyle())
                     
                        Text("isPlaying \(isPlaying ? "1" : "0")")
                        Text("isReady \(isReady ? "1" : "0")")
                        Text("isMuted \(isMuted ? "1" : "0" )")
                        Text("seeking \(seeking ? "1" : "0")")
                        Text("videoPos \(videoPos)")
                        Text("videoDuration \(videoDuration)")
                       
                    }
                   
                )
        }
    }
}


extension ContentView{
    
    var playerId:String{
        "homeVideo"
    }
    
    var videoURL:URL{
        Bundle.main.url(forResource: playerId, withExtension: "mp4")!
    }
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
