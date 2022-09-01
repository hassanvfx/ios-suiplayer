//
//  ContentView.swift
//  DemoApp
//
//  Created by hassan uriostegui on 8/30/22.
//

import AVFoundation
import SUIPlayer
import SwiftUI

struct ContentView: View {
    @StateObject var playerPub1 = SUIPlayerModel(
        id: "Player 1",
        url: Bundle.main.url(forResource: "homeVideo", withExtension: "mp4")!,
        muted: false,
        autoplay: true,
        loop: true,
        publishVideoPos: true
    )

    @StateObject var playerPub2 = SUIPlayerModel(
        id: "Player 2",
        url: Bundle.main.url(forResource: "homeVideo", withExtension: "mp4")!,
        muted: true,
        autoplay: false,
        loop: true,
        publishVideoPos: true
    )

    @StateObject var playerPub3 = SUIPlayerModel(
        id: "Player 3",
        url: Bundle.main.url(forResource: "homeVideo", withExtension: "mp4")!,
        muted: false,
        autoplay: true,
        loop: false,
        publishVideoPos: false
    )

    @StateObject var playerPub4 = SUIPlayerModel(
        id: "Player 4",
        url: Bundle.main.url(forResource: "homeVideo", withExtension: "mp4")!,
        muted: true,
        autoplay: false,
        loop: false,
        publishVideoPos: false
    )

    var body: some View {
        VStack {
            VStack {
                GeometryReader { geo in
                    ZStack {
                        SUIPlayerView(model: playerPub1)
                            .suiPlayerDebugOverlay(model: playerPub1)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)

                        SUIPlayerView(model: playerPub2)
                            .suiPlayerDebugOverlay(model: playerPub2)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)

                        SUIPlayerView(model: playerPub3)
                            .suiPlayerDebugOverlay(model: playerPub3)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomLeading)

                        SUIPlayerView(model: playerPub4)
                            .suiPlayerDebugOverlay(model: playerPub4)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomTrailing)
                    }
                }
                Text("NOTE:Pause all players to keep them disposed. This is because the player observers trigger a view redraw and then the other players may trigger a reconstruction")
                    .font(.caption)
                    .padding()

                HStack {
                    Button(action: pauseAll) {
                        Text("Pause All")
                    }
                    .buttonStyle(BorderedButtonStyle())

                    Button(action: disposeAll) {
                        Text("Dispose All")
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding()
            }
        }
    }
}

extension ContentView {
    func pauseAll() {
        playerPub1.controls.pause()
        playerPub2.controls.pause()
        playerPub3.controls.pause()
        playerPub4.controls.pause()
    }

    func disposeAll() {
        pauseAll()
        playerPub1.controls.dispose()
        playerPub2.controls.dispose()
        playerPub3.controls.dispose()
        playerPub4.controls.dispose()
    }
}

extension ContentView {
    @ViewBuilder
    func playerDisplay(model: SUIPlayerModel) -> some View {
        //        if let controls = model.controls {
        let controls = model.controls
        VStack {
            SUIPlayerView(model: model)
                .onDisappear {
                    controls.dispose()
                }
                .overlay(
                    VStack {
                        HStack {
                            Group {
                                Button(action: controls.pause) {
                                    Text("Pause")
                                }
                                .buttonStyle(BorderedButtonStyle())

                                Button(action: controls.play) {
                                    Text("Play")
                                }
                                .buttonStyle(BorderedButtonStyle())

                                Button(action: controls.dispose) {
                                    Text("Dispose")
                                }
                                .buttonStyle(BorderedButtonStyle())
                            }
                            .font(.caption)
                            .background(Color.black.opacity(1))
                            .foregroundColor(.white)
                        }
                        Group {
                            Text("\(model.controls.playerId)").bold()
                            Text("\(String(model.controls.playbackId.prefix(4)))").bold()
                            Text("muted \(model.controls.muted ? "1" : "0")").bold()
                            Text("autoplay \(model.controls.autoplay ? "1" : "0")").bold()
                            Text("loop \(model.controls.loop ? "1" : "0")").bold()
                            Text("isReady \(model.isReady ? "1" : "0")")
                            Text("isMuted \(model.isMuted ? "1" : "0")")
                            Text("seeking \(model.seeking ? "1" : "0")")
                            Text("videoPos \(model.videoPos)")
                            Text("videoDuration \(model.videoDuration)")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                    .background(Color.black.opacity(0.5))
                )
        }
        //        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
