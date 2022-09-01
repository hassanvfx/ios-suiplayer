//
//  File.swift
//
//
//  Created by hassan uriostegui on 8/31/22.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func suiPlayerDebugOverlay(model: SUIPlayerModel) -> some View {
        modifier(SUIPlayerDebugView(model: model))
    }
}

public struct SUIPlayerDebugView: ViewModifier {
    @ObservedObject var model: SUIPlayerModel
    @State var hidden = false
    public init(model: SUIPlayerModel) {
        self.model = model
    }

    @ViewBuilder
    public func body(content: Self.Content) -> some View {
        content
            .overlay(
                VStack {
                    HStack {
                        Group {
                            Button(action: model.controls.pause) {
                                Text("Pause")
                                    .padding(4)
                            }

                            Button(action: model.controls.play) {
                                Text("Play")
                                    .padding(4)
                            }

                            Button(action: model.controls.dispose) {
                                Text("Dispose")
                                    .padding(4)
                            }
                        }
                        .font(.caption)
                        .background(Color.black.opacity(1))
                        .foregroundColor(.white)
                    }
                    .opacity(hidden ? 0 : 1)
                    Group {
                        Text("\(model.controls.playerId)").bold()
                        Text("\(String(model.playbackId.prefix(4)))").bold()
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
                    .opacity(hidden ? 0 : 1)

                    Button(action: { hidden.toggle() }) {
                        Text(hidden ? "Show Overlay" : "Hide Overlay")
                            .bold()
                            .padding()
                    }
                    .foregroundColor(.white)
                }
                .background(
                    model.isReady
                        ? Color.black.opacity(hidden ? 0.0 : 0.5)
                        : Color.red.opacity(hidden ? 0.0 : 0.5))
            )
    }
}
