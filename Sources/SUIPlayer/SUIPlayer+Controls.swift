//
//  File.swift
//  
//
//  Created by hassan uriostegui on 8/31/22.
//

import Foundation
import AVFoundation
import SwiftUI

public extension SUIPlayer {
    struct  Controls {
        public lazy var playerLayer = AVPlayerLayer()
       
        public var playerId:String
        public var url: URL
        public var muted: Bool = false
        public var autoplay: Bool = true
        public var loop: Bool = true
        
        @Binding public var isReady: Bool
        @Binding public var isPlaying: Bool
        @Binding public var isMuted: Bool
        @Binding public var volume: Float
        @Binding public var videoPos: Double
        @Binding public var videoDuration: Double
        @Binding public var seeking: Bool
        @Binding public var playbackId: String

        public init(id:StringId, url: URL, isReady: Binding<Bool> = .constant(false), isPlaying: Binding<Bool> = .constant(false), isMuted: Binding<Bool> = .constant(false), volume: Binding<Float> = .constant(0), videoPos: Binding<Double>, videoDuration: Binding<Double>, seeking: Binding<Bool>, playbackId:  Binding<String>? = nil) {
            self.playerId=id
            self.url = url
            _isReady = isReady
            _volume = volume
            _isPlaying = isPlaying
            _isMuted = isMuted
            _videoPos = videoPos
            _videoDuration = videoDuration
            _seeking = seeking
            _playbackId = playbackId ?? .constant( UUID().uuidString)
        }
        
        public func newSession(){
            DispatchQueue.main.async {
                self.playbackId = UUID().uuidString
            }
        }
    }
}
