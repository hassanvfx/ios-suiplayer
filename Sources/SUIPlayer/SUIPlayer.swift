//
//  AVPlayerUI.swift
//  Exploration1
//
//  Created by hassan on 10/10/20.
//

import AVFoundation
import SwiftUI

public typealias StringId = String
public enum SUIPlayer {}

extension SUIPlayer {
    enum PlayerFetching {
        case newPlayer
        case cachedPlayer
    }

    private static var players: [StringId: AVPlayer] = [:]

    /// we require an id as a video with the same url may be played in multiple parts of the view composition
    static func player(_ url: URL, id: String, muted: Bool = false, autoplay: Bool = false) -> (player: AVPlayer, fetched: PlayerFetching) {
        var players = self.players

        if let player = players[id],
           player.currentItem != nil,
           player.currentItem?.status != .failed,
           let asset = player.currentItem?.asset as? AVURLAsset,
           asset.url == url
        {
            // LogService.debug(.player, "player \(id) returned cached")
            return (player: player, fetched: .cachedPlayer)
        }

        // LogService.debug(.player, "player \(id) being created")
        dispose(playerId: id)

        let preparePlayer: (AVPlayer) -> Void = { player in
            // LogService.debug(.player, "player \(id) being prepared to loop")
            loop(player: player)
            player.volume = muted ? 0 : 1
            autoplay ? player.playImmediately(atRate: 1) : nil
        }

        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)

        players[id] = player
        self.players = players
        preparePlayer(player)

        return (player: player, fetched: .newPlayer)
    }

    static func loop(player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero) { _ in
                DispatchQueue.main.async {
                    player.play()
                }
            }
        }
    }
}

public extension SUIPlayer {
    static func dispose(playerId: String) {
        var players = self.players
        if let player = players[playerId] {
            // LogService.debug(.player, "player \(playerId) being disposed")
            player.pause()
            player.replaceCurrentItem(with: nil)
        }
        players.removeValue(forKey: playerId)
        self.players = players
        // LogService.debug(.player, "player \(playerId) was disposed")
    }
}
