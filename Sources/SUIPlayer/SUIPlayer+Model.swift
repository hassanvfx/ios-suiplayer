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

    public var isReady: Bool = false
    public var isPlaying = false
    public var isMuted = false
    @Published public var videoPos = 0.0
    public var videoDuration = 0.0
    public var seeking = false
    @Published public var playbackId = ""
    public var controls: SUIPlayer.Controls

    lazy var playbackIdBinding = Binding(
        get: { [weak self] in
            self?.playbackId ?? ""
        },
        set: { [weak self] in
            self?.playbackId = $0
        }
    )

    lazy var isReadyBinding = Binding(
        get: { [weak self] in
            self?.isReady ?? false
        },
        set: { [weak self] in
            self?.isReady = $0
        }
    )

    lazy var isPlayingBinding = Binding(
        get: { [weak self] in
            self?.isPlaying ?? false
        },
        set: { [weak self] in
            self?.isPlaying = $0
        }
    )

    lazy var videoPosBinding = Binding(
        get: { [weak self] in
            self?.videoPos ?? -1
        },
        set: { [weak self] in
            self?.videoPos = $0
        }
    )

    lazy var videoDurationBinding = Binding(
        get: { [weak self] in
            self?.videoDuration ?? -1
        },
        set: { [weak self] in
            self?.videoDuration = $0
        }
    )

    lazy var seekingBinding = Binding(
        get: { [weak self] in
            self?.seeking ?? false
        },
        set: { [weak self] in
            self?.seeking = $0
        }
    )

    public init(id: String,
                url: URL,
                muted: Bool = false,
                autoplay: Bool = true,
                loop: Bool = true)
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
            playbackId: playbackIdBinding,
            isReady: isReadyBinding,
            isPlaying: isPlayingBinding,
            videoPos: videoPosBinding,
            videoDuration: videoDurationBinding,
            seeking: seekingBinding
        )
    }
}
