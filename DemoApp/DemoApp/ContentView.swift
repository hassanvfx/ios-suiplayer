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
    
    /// TODO we require to notify inner player changes back to the view so it can reconstruct
    /// the representable view and link the AVPlayerLayer with any new players associated to this playerId
    /// while  `.id(videoPlayer.currentItem)`  ensures to recreate the `AVPlayerView` when needed
    /// we still require an external mechanism that observes the inner changes in the AVPLayer (ie different current item after disposal)
    /// a solution instead of the `status` state patched here, could be to use the Controls as a required parameter to interface the player and then, internally recreate the status prop whenever a  new player is constructed, so we can trigger the relinking wit the avplayerview
    ///
    ///  so overall
    ///   - use the `control` struct as the only in-out inteface
    ///   - encapsulate `url` into the `control` struct
    ///   - make private the `avplayer` and instead expose control through the `control` struct
    ///    - use the control struct to dispose the player and then internally trigger a new inner session
    ///    - when a new player is created with also set a new inner session to triiger UI player layer linking
    @State var status = UUID().uuidString
  
    @State var isReady:Bool = false
    @State var isPlaying = false
    @State var isMuted = false
    @State var videoPos = 0.0
    @State var videoDuration = 0.0
    @State var seeking = false
    
    var body: some View {
        VStack{
            SUIPlayer.AVPlayerView(player: videoPlayer, controls: controls )
                .id(videoPlayer.currentItem)
                .onAppear {
                    videoPlayer.play()
                }
                .onDisappear {
                    videoPlayer.pause()
                }
                .overlay(
                    VStack{
                       
                        Button(action: { videoPlayer.pause() }){
                            Text("Pause")
                        }
                        .buttonStyle(BorderedButtonStyle())
                        
                        
                        Button(action: {
                            videoPlayer.play()
                            status = UUID().uuidString
                        }){
                            Text("Play")
                        }
                        .buttonStyle(BorderedButtonStyle())
                        
                        
                        Button(action: {SUIPlayer.dispose(playerId: playerId)}){
                            Text("Dispose")
                        }
                        .buttonStyle(BorderedButtonStyle())
                     
                        Text("isPlaying \(isPlaying ? "1" : "0")")
                        Text("isReady \(isReady ? "1" : "0")")
                        Text("isMuted \(isMuted ? "1" : "0" )")
                        Text("seeking \(seeking ? "1" : "0")")
                        Text("videoPos \(videoPos)")
                        Text("videoDuration \(videoDuration)")
                        Text(status.suffix(4))
                    }
                   
                )
        }
    }
}

extension ContentView{
    var controls: SUIPlayer.AVPlayerControls {
        SUIPlayer.AVPlayerControls(
            isReady: $isReady,
            isPlaying: $isPlaying,
            videoPos: $videoPos,
            videoDuration: $videoDuration,
            seeking: $seeking
        )
    }
    
}

extension ContentView{
    
    var playerId:String{
        "homeVideo"
    }
    
    var videoURL:URL{
        Bundle.main.url(forResource: playerId, withExtension: "mp4")!
    }
    var videoPlayer:AVPlayer{
        SUIPlayer.fetch(videoURL, id: playerId, muted: true, autoplay: true)
    }
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
