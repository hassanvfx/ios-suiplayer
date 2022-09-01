//
//  File.swift
//
//
//  Created by hassan uriostegui on 8/31/22.
//

import AVFoundation
import Foundation
import SwiftUI

public extension SUIPlayer {
    struct Controls {
        public lazy var playerLayer = AVPlayerLayer()

        public var playerId: String
        public var url: URL
        public var muted: Bool = false
        public var autoplay: Bool = true
        public var loop: Bool = true

        @Binding public var playbackId: String
        @Binding public var isReady: Bool
        @Binding public var isPlaying: Bool
        @Binding public var isMuted: Bool
        @Binding public var volume: Float
        @Binding public var videoPos: Double
        @Binding public var videoDuration: Double
        @Binding public var seeking: Bool

        public init(id: StringId,
                    url: URL,
                    muted: Bool = false,
                    autoplay: Bool = false,
                    loop: Bool = true,
                    playbackId: Binding<String> = .constant(UUID().uuidString),
                    isReady: Binding<Bool> = .constant(false),
                    isPlaying: Binding<Bool> = .constant(false),
                    isMuted: Binding<Bool> = .constant(false),
                    volume: Binding<Float> = .constant(0),
                    videoPos: Binding<Double> = .constant(0),
                    videoDuration: Binding<Double> = .constant(0),
                    seeking: Binding<Bool> = .constant(false))
        {
            playerId = id
            self.url = url
            self.muted = muted
            self.autoplay = autoplay
            self.loop = loop
            _isReady = isReady
            _volume = volume
            _isPlaying = isPlaying
            _isMuted = isMuted
            _videoPos = videoPos
            _videoDuration = videoDuration
            _seeking = seeking
            _playbackId = playbackId
        }

        public func newSession() {
            playbackId = UUID().uuidString
        }
    }
}

public extension SUIPlayer.Controls {
    
    func fetchPlayer()->AVPlayer{
        let fetch = SUIPlayer.player(url, id: playerId, muted: muted, autoplay: autoplay)

        if fetch.fetched == .newPlayer {
            newSession()
        }
        
        return fetch.player
    }
    
    func set(volume:Float){
        let player = fetchPlayer()
        player.volume = volume
    }
    
    func playPause() {
        let player = fetchPlayer()

        guard player.currentItem != nil else { return }
        player.rate > 0 ? player.pause() : player.play()
    }

    func rewind() {
        let player = fetchPlayer()
        
        player.seek(to: .zero) { _ in
            player.play()
        }
    }
}

public extension SUIPlayer.Controls {
    func play() {
        let player = fetchPlayer()

        guard player.isAtEnd == false else {
            player.seek(to: .zero) { _ in
                player.play()
            }
            return
        }
        player.play()
    }

    func pause() {
        let player = fetchPlayer()
        player.pause()
    }

    func dispose() {
        SUIPlayer.dispose(playerId: playerId)
    }
}

extension AVPlayer {
    var isAtEnd: Bool {
        guard let currentItem = currentItem else {
            return false
        }

        var time = currentTime().seconds
        time = time.isNormal ? time : 0
        var duration = currentItem.duration.seconds
        duration = duration.isNormal ? duration : 0

        return Int(time) >= Int(duration)
    }
}
