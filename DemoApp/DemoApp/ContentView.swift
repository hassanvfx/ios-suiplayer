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
    @StateObject var player1 = SUIPlayerModel(
        id: "Player 1",
        url: Bundle.main.url(forResource: "homeVideo", withExtension: "mp4")!,
        muted: false,
        autoplay: true,
        loop: true,
        publishVideoPos: true
    )

    @StateObject var player2 = SUIPlayerModel(
        id: "Player 2",
        url: URL(string: "https://download.samplelib.com/mp4/sample-5s.mp4")!,
        muted: true,
        autoplay: true,
        loop: true,
        publishVideoPos: true
    )

    @StateObject var player3 = SUIPlayerModel(
        id: "Player 3",
        url: Bundle.main.url(forResource: "homeVideo", withExtension: "mp4")!,
        muted: false,
        autoplay: true,
        loop: false,
        publishVideoPos: true
    )

    @StateObject var player4 = SUIPlayerModel(
        id: "Player 4",
        url: Bundle.main.url(forResource: "homeVideo", withExtension: "mp4")!,
        muted: true,
        autoplay: false,
        loop: false,
        publishVideoPos: true
    )

    var body: some View {
        VStack {
            VStack {
                GeometryReader { geo in
                    ZStack {
                        SUIPlayerView(model: player1)
                            .suiPlayerDebugOverlay(model: player1)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)

                        SUIPlayerView(model: player2)
                            .suiPlayerDebugOverlay(model: player2)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)

                        SUIPlayerView(model: player3)
                            .suiPlayerDebugOverlay(model: player3)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomLeading)

                        SUIPlayerView(model: player4)
                            .suiPlayerDebugOverlay(model: player4)
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5, alignment: .center)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomTrailing)
                    }
                }

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
        player1.controls.pause()
        player2.controls.pause()
        player3.controls.pause()
        player4.controls.pause()
    }

    func disposeAll() {
        pauseAll()
        player1.controls.dispose()
        player2.controls.dispose()
        player3.controls.dispose()
        player4.controls.dispose()
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
