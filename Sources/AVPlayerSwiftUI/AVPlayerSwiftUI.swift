//
//  AVPlayerUI.swift
//  Exploration1
//
//  Created by hassan on 10/10/20.
//

import AVFoundation
import SwiftUI

public enum AVPlayerSwiftUI {
    typealias StringId = String
}


extension AVPlayerSwiftUI {
   
    static private var players: [StringId: AVPlayer] = [:]
    
    /// we require an id as a video with the same url may be played in multiple parts of the view composition
    static func player(_ url: URL, id:String, muted: Bool = false, autoplay: Bool = false) -> AVPlayer {
       
        var players = self.players
        
        if let player = players[id],
           player.currentItem != nil,
           player.currentItem?.status != .failed,
           let asset = player.currentItem?.asset as? AVURLAsset,
           asset.url == url
        {
            //LogService.debug(.player, "player \(id) returned cached")
            return player
        }
        
        //LogService.debug(.player, "player \(id) being created")
        dispose(playerId: id)
        
        let preparePlayer:(AVPlayer)->Void = { player in
            //LogService.debug(.player, "player \(id) being prepared to loop")
            loop(player: player)
            player.volume = muted ? 0 : 1
            autoplay ? player.playImmediately(atRate: 1) : nil
        }
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        
        players[id] = player
        self.players = players
        preparePlayer(player)
        
        return player
    }
    
    static func loop(player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero) { (value) in
                DispatchQueue.main.async {
                    player.play()
                }
            }
        }
    }
}

public extension AVPlayerSwiftUI{
    
    static func dispose(playerId:String){
        var players = self.players
        if let player = players[playerId]{
            //LogService.debug(.player, "player \(playerId) being disposed")
            player.replaceCurrentItem(with: nil)
        }
        players.removeValue(forKey: playerId)
        self.players = players
        //LogService.debug(.player, "player \(playerId) was disposed")
    }
}


public extension AVPlayerSwiftUI {
    struct AVPlayerControls {
        public lazy var playerLayer = AVPlayerLayer()
        @Binding public var isReady: Bool
        @Binding public var isPlaying: Bool
        @Binding public var isMuted: Bool
        @Binding public var volume: Float
        @Binding public var videoPos: Double
        @Binding public var videoDuration: Double
        @Binding public var seeking: Bool

        public init(isReady: Binding<Bool> = .constant(false), isPlaying: Binding<Bool> = .constant(false), isMuted: Binding<Bool> = .constant(false), volume: Binding<Float> = .constant(0), videoPos: Binding<Double>, videoDuration: Binding<Double>, seeking: Binding<Bool>) {
            _isReady = isReady
            _volume = volume
            _isPlaying = isPlaying
            _isMuted = isMuted
            _videoPos = videoPos
            _videoDuration = videoDuration
            _seeking = seeking
        }
    }
}
