//
//  CustomVideoPLayer.swift
//  videomapping
//
//  Created by digital on 27/12/2022.
//

import Foundation
import AVKit
import SwiftUI


struct CustomVideoPlayer: NSViewRepresentable {
    var player: AVPlayer

    func updateNSView(_ NSView: NSView, context: NSViewRepresentableContext<CustomVideoPlayer>) {
        guard let view = NSView as? AVPlayerView else {
            debugPrint("unexpected view")
            return
        }

        view.player = player
        view.showsFullScreenToggleButton = true
    }

    func makeNSView(context: Context) -> NSView {
        return AVPlayerView(frame: .zero)
    }
}
