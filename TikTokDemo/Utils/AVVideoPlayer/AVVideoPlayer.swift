//
//  AVVideoPlayer.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

import UIKit
import Stevia
import AVFoundation

protocol CustomVideoPlayerDelegate: AnyObject {
    func didStartPlaying()
    func didPausePlaying()
}

class AVVideoPlayer: UIView {
    // MARK: Properties
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    weak var delegate: CustomVideoPlayerDelegate?
    
    // MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerLayer()
    }
    
    // MARK: Private Methods
    private func setupPlayerLayer() {
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = .resizeAspectFill
        self.layer.addSublayer(playerLayer!)
    }
    
    // MARK: Public Methods
    func configure(with url: String) {
        guard let url = URL(string: url) else { return }
        player = AVPlayer(url: url)
        playerLayer?.player = player
        player?.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: .zero)
                self?.delegate?.didStartPlaying()
                self?.player?.play()
            }
    }
    
    func play() {
        player?.play()
        delegate?.didStartPlaying()
    }
    
    func pause() {
        player?.pause()
        delegate?.didPausePlaying()
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            pause()
        } else {
            play()
        }
    }
    
    // MARK: De-Initialisation
    deinit {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(self)
    }
}
