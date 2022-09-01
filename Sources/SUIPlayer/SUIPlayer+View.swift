
//
//  AVPlayerView.swift
//  Exploration1
//
//  Created by hassan on 10/10/20.
//

import AVFoundation
import Lux
import SwiftUI

public struct SUIPlayerView: View {
    @ObservedObject var model: SUIPlayerModel
    public init(model: SUIPlayerModel) {
        self.model = model
    }

    public var body: some View {
        SUIPlayer.RepresentableView(controls: model.controls)
            .id(model.playbackId)
            .onDisappear {
                model.controls.dispose()
            }
    }
}

public extension SUIPlayer {
    @ViewBuilder
    static func RepresentableView(controls: SUIPlayer.Controls) -> some View {
        let player = SUIPlayer.player(controls.url, id: controls.playerId, muted: controls.muted, autoplay: controls.autoplay, looping: controls.loop)

        SUIPlayer.AVPlayerView(player: player.player, controls: controls)
            .id(player.player.currentItem)
    }
}

// This is the SwiftUI view which wraps the UIKit-based PlayerUIView above
public extension SUIPlayer {
    struct AVPlayerView: UIViewRepresentable {
        let player: AVPlayer
        var controls: Controls
        public init(player: AVPlayer, controls: Controls) {
            self.player = player
            self.controls = controls
        }
    }
}

public extension SUIPlayer.AVPlayerView {
    func updateUIView(_: UIView, context _: UIViewRepresentableContext<SUIPlayer.AVPlayerView>) {
        // This function gets called if the bindings change, which could be useful if
        // you need to respond to external changes, but we don’t in this example
    }

    func makeUIView(context _: UIViewRepresentableContext<SUIPlayer.AVPlayerView>) -> UIView {
        let uiView = SUIPlayer.AVPlayerUIView(player: player,
                                              controls: controls)
        return uiView
    }

    static func dismantleUIView(_ uiView: UIView, coordinator _: ()) {
        guard let playerUIView = uiView as? SUIPlayer.AVPlayerUIView else {
            return
        }
        playerUIView.cleanUp()
    }
}

public extension SUIPlayer {
    // This is the SwiftUI view that contains the controls for the player
    struct ControlsView: View {
        @Binding private(set) var videoPos: Double
        @Binding private(set) var videoDuration: Double
        @Binding private(set) var seeking: Bool
        let player: AVPlayer
        @State private var playerPaused = true
        public init(videoPos: Binding<Double>, videoDuration: Binding<Double>, seeking: Binding<Bool>, player: AVPlayer) {
            _videoPos = videoPos
            _videoDuration = videoDuration
            _seeking = seeking
            self.player = player
        }
    }
}

public extension SUIPlayer.ControlsView {
    var body: some View {
        Row {
            // Play/pause button
            Group {
                Button(action: togglePlayPause) {
                    Image(systemName: playerPaused ? "play" : "pause")
                        .padding(.trailing, 10)
                }
                // Current video time
                Text("\(SUIPlayer.Utility.formatSecondsToHMS(videoPos * videoDuration))")
            }
            .lux
            .style(.icon)
            .feature(.shadow)
            .view
            // Slider for seeking / showing video progress
            Slider(value: $videoPos, in: 0 ... 1, onEditingChanged: sliderEditingChanged)
            // Video duration
            Group {
                Text("\(SUIPlayer.Utility.formatSecondsToHMS(videoDuration))")
            }
            .lux
            .tweak(.paddingQuarter)
            .style(.icon)
            .view
        }
        .lux
        .tweak(.captionLayout)
        .style(.paragraph)
        .view
    }

    private func togglePlayPause() {
        pausePlayer(!playerPaused)
    }

    private func pausePlayer(_ pause: Bool) {
        playerPaused = pause
        if playerPaused {
            player.pause()
        } else {
            player.play()
        }
    }

    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Set a flag stating that we’re seeking so the slider doesn’t
            // get updated by the periodic time observer on the player
            seeking = true
            pausePlayer(true)
        }
        // Do the seek if we’re finished
        if !editingStarted {
            let targetTime = CMTime(seconds: videoPos * videoDuration,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the seek is finished, resume normal operation
                self.seeking = false
                //        self.pausePlayer(false)
            }
        }
    }
}

public extension SUIPlayer {
    // This is the SwiftUI view which contains the player and its controls
    struct AVPlayerContainerView: View {
        // The progress through the video, as a percentage (from 0 to 1)
        var playerId: String
        var url: URL
        @State private var videoPos: Double = 0
        // The duration of the video in seconds
        @State private var videoDuration: Double = 0
        // Whether we’re currently interacting with the seek bar or doing a seek
        @State private var seeking = false
        private let player: AVPlayer
        init(playerId: StringId, url: URL) {
            player = AVPlayer(url: url)
            self.url = url
            self.playerId = playerId
        }
    }
}

public extension SUIPlayer.AVPlayerContainerView {
    var controls: SUIPlayer.Controls {
        SUIPlayer.Controls(
            id: playerId,
            url: url,
            videoPos: $videoPos,
            videoDuration: $videoDuration,
            seeking: $seeking
        )
    }

    var body: some View {
        VStack {
            SUIPlayer.AVPlayerView(player: player, controls: controls)
            SUIPlayer.ControlsView(videoPos: $videoPos,
                                   videoDuration: $videoDuration,
                                   seeking: $seeking,
                                   player: player)
        }
        .onDisappear {
            // When this View isn’t being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}

public extension SUIPlayer {
    // This is the SwiftUI view which contains the player and its controls
    struct AVPlayerCoverView: View {
        var playerId: StringId
        var url: URL
        @State private var videoPos: Double = 0
        @State private var videoDuration: Double = 0
        @State private var seeking = false
        private let player: AVPlayer
        init(playerId: String, url: URL) {
            player = AVPlayer(url: url)
            self.url = url
            self.playerId = playerId
        }
    }
}

public extension SUIPlayer.AVPlayerCoverView {
    var controls: SUIPlayer.Controls {
        var controls = SUIPlayer.Controls(
            id: playerId,
            url: url,
            videoPos: $videoPos,
            videoDuration: $videoDuration,
            seeking: $seeking
        )
        controls.playerLayer.videoGravity = .resizeAspectFill
        return controls
    }

    var body: some View {
        SUIPlayer.AVPlayerView(player: player, controls: controls)
            .animation(.none)
    }
}

public extension SUIPlayer {
    class Utility: NSObject {
        private static var timeHMSFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = [.pad]
            return formatter
        }()

        public static func formatSecondsToHMS(_ seconds: Double) -> String {
            guard !seconds.isNaN, seconds.isFinite else { return "00:00" }
            return timeHMSFormatter.string(from: seconds) ?? "00:00"
        }
    }
}

public extension SUIPlayer {
    // This is the UIView that contains the AVPlayerLayer for rendering the video
    class AVPlayerUIView: UIView {
        private let player: AVPlayer
        var controls: Controls

        private var durationObservation: NSKeyValueObservation?
        private var timeObservation: Any?

        init(player: AVPlayer, controls: Controls) {
            self.player = player
            self.controls = controls
            super.init(frame: .zero)
            backgroundColor = .clear

            let avLayer = self.controls.playerLayer
            avLayer.player = player
            avLayer.backgroundColor = UIColor.clear.cgColor
            avLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(avLayer)

            // Observe the duration of the player’s item so we can display it
            // and use it for updating the seek bar’s position
            durationObservation = player.currentItem?.observe(\.duration, changeHandler: { [weak self] item, _ in
                guard let self = self, self.player.currentItem != nil else { return }
                self.controls.$videoDuration.wrappedValue = item.duration.seconds
            })
            // Observe the player’s time periodically so we can update the seek bar’s
            // position as we progress through playback
            timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.123, preferredTimescale: 1000), queue: nil) { [weak self] time in
                guard let self = self, self.player.currentItem != nil else { return }
                // If we’re not seeking currently (don’t want to override the slider
                // position if the user is interacting)

                DispatchQueue.main.async {
                    if self.controls.$seeking.wrappedValue == false {
                        self.controls.videoPos = time.seconds / self.controls.$videoDuration.wrappedValue
                    }
                    self.controls.isReady = self.player.currentItem?.status == AVPlayerItem.Status.readyToPlay
                    self.controls.volume = self.player.volume
                    self.controls.isPlaying = self.player.rate > 0
                    self.controls.isMuted = self.player.volume == 0
//                    //LogService.debug(.miscellaneous, "volume = \(self.player.volume)")
//                    //LogService.debug(.miscellaneous, "volume = \(self.controls.volume)")
                }
            }
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            // LogService.assert(.miscellaneous, "init(coder:) has not been implemented")
            return nil
        }
    }
}

public extension SUIPlayer.AVPlayerUIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        controls.playerLayer.frame = bounds
    }

    func cleanUp() {
        player.replaceCurrentItem(with: nil)

        // Remove observers we setup in init
        durationObservation?.invalidate()
        durationObservation = nil
        if let observation = timeObservation {
            player.removeTimeObserver(observation)
            timeObservation = nil
        }
    }
}
