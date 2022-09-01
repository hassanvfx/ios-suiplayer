//
//  File.swift
//
//
//  Created by hassan uriostegui on 8/31/22.
//

import SwiftUI

public class PlayerModel: ObservableObject {
    /// The Controls struct works as a disposable  connector that allows to fetch the correspoding player
    /// and interface with the inner control status
    /// In itself the controls are not observable intentionally as we want to modularize the updates observation
    /// instead, the controls can be binded to observable states as required
    /// - if a player is meant to be diposed then we should use `.id(playbackId)` to ensure the view will be redrawn when a new player is created
    ///

    @Published public var isReady: Bool = false
    @Published public var isPlaying = false
    @Published public var isMuted = false
    @Published public var videoPos = 0.0
    @Published public var videoDuration = 0.0
    @Published public var seeking = false
    @Published public var playbackId = ""
    @Published public var controls: SUIPlayer.Controls

    lazy var playbackIdBinding = Binding(
        get: { [weak self] in
            self?.playbackId ?? ""
        },
        set: { [weak self] in
            guard $0 != self?.playbackId else { return }
            self?.playbackId = $0
        }
    )

    lazy var isReadyBinding = Binding(
        get: { [weak self] in
            self?.isReady ?? false
        },
        set: { [weak self] in
            guard $0 != self?.isReady else { return }
            self?.isReady = $0
        }
    )

    lazy var isPlayingBinding = Binding(
        get: { [weak self] in
            self?.isPlaying ?? false
        },
        set: { [weak self] in
            guard $0 != self?.isPlaying else { return }
            self?.isPlaying = $0
        }
    )

    lazy var videoPosBinding = Binding(
        get: { [weak self] in
            self?.videoPos ?? -1
        },
        set: { [weak self] in
            guard $0 != self?.videoPos else { return }
            self?.videoPos = $0
        }
    )

    lazy var videoDurationBinding = Binding(
        get: { [weak self] in
            self?.videoDuration ?? -1
        },
        set: { [weak self] in
            guard $0 != self?.videoDuration else { return }
            self?.videoDuration = $0
        }
    )

    lazy var seekingBinding = Binding(
        get: { [weak self] in
            self?.seeking ?? false
        },
        set: { [weak self] in
            guard $0 != self?.seeking else { return }
            self?.seeking = $0
        }
    )

    public init(id: String,
                url: URL,
                muted: Bool = false,
                autoplay: Bool = true,
                loop: Bool = true,
                publishPlaybackId: Bool = true,
                publishIsReady: Bool = true,
                publishIsPlaying: Bool = true,
                publishVideoPos: Bool = false,
                publishVideoDuration: Bool = true,
                publishSeeking: Bool = false)
    {
        controls = SUIPlayer.Controls(
            id: id,
            url: url
        )

        controls = SUIPlayer.Controls(
            id: id,
            url: url,
            muted: muted,
            autoplay: autoplay,
            loop: loop,
            playbackId: publishPlaybackId ? playbackIdBinding : .constant(""),
            isReady: publishIsReady ? isReadyBinding : .constant(false),
            isPlaying: publishIsPlaying ? isPlayingBinding : .constant(false),
            videoPos: publishVideoPos ? videoPosBinding : .constant(0),
            videoDuration: publishVideoDuration ? videoDurationBinding : .constant(0),
            seeking: publishSeeking ? seekingBinding : .constant(false)
        )
    }
}
