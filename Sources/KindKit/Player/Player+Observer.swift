//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation

extension Player {
    
    class Observer : NSObject {
        
        weak var handler: Player?
        var player: AVPlayer? {
            willSet {
                guard self.player != newValue else { return }
                if let player = self.player {
                    player.removeTimeObserver(self._timeObserver!)
                }
            }
            didSet {
                guard self.player != oldValue else { return }
                if let player = self.player {
                    self._timeObserver = player.addPeriodicTimeObserver(
                        forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                        queue: .main,
                        using: { [weak self] time in
                            guard let self = self else { return }
                            self._change(time: time)
                        }
                    )
                }
            }
        }
        var item: AVPlayerItem? {
            willSet {
                guard self.item != newValue else { return }
                guard let item = self.item else { return }
                item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
                item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
                item.removeObserver(self, forKeyPath: "playbackBufferFull")
                item.removeObserver(self, forKeyPath: "status")
#if os(macOS)
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: item)
#elseif os(iOS)
                NotificationCenter.default.removeObserver(self, name: AVPlayerItem.didPlayToEndTimeNotification, object: item)
#endif
                NotificationCenter.default.removeObserver(self, name: AVPlayerItem.timeJumpedNotification, object: item)
            }
            didSet {
                guard self.item != oldValue else { return }
                guard let item = self.item else { return }
#if os(macOS)
                NotificationCenter.default.addObserver(self, selector: #selector(self._didPlayToEndTime(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: item)
#elseif os(iOS)
                NotificationCenter.default.addObserver(self, selector: #selector(self._didPlayToEndTime(notification:)), name: AVPlayerItem.didPlayToEndTimeNotification, object: item)
#endif
                NotificationCenter.default.addObserver(self, selector: #selector(self._timeJumped(notification:)), name: AVPlayerItem.timeJumpedNotification, object: item)
                item.addObserver(self, forKeyPath: "status", context: nil)
                item.addObserver(self, forKeyPath: "playbackBufferFull", context: nil)
                item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
                item.addObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
            }
        }
        
        private var _timeObserver: Any?
        
        init(handler: Player) {
            self.handler = handler
            super.init()
        }
        
        @objc
        func _change(time: CMTime) {
            guard let handler = self.handler else {
                return
            }
            handler.change(time: time)
        }
        
        @objc
        func _timeJumped(notification: NSNotification) {
            guard let handler = self.handler else {
                return
            }
            handler.skip()
        }
        
        @objc
        func _didPlayToEndTime(notification: NSNotification) {
            guard let handler = self.handler else {
                return
            }
            handler.change(status: .finish)
        }
        
        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey : Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            guard let handler = self.handler else {
                return
            }
            if let item = object as? AVPlayerItem {
                switch keyPath ?? "" {
                case "status":
                    switch item.status {
                    case .unknown:
                        break
                    case .readyToPlay:
                        handler.change(status: .ready)
                    case .failed:
                        if let itemError = item.error as NSError?, let underlyingError = itemError.userInfo[NSUnderlyingErrorKey] as? NSError {
                            let error: Player.Error
                            switch underlyingError.code {
                            case -12937: error = .authenticationError
                            case -16840: error = .unauthorized
                            case -12660: error = .forbidden
                            case -12938: error = .notFound
                            case -12661: error = .unavailable
                            case -12645, -12889: error = .mediaFileError
                            case -12318: error = .bandwidthExceeded
                            case -12642: error = .playlistUnchanged
                            case -12911: error = .decoderMalfunction
                            case -12913: error = .decoderTemporarilyUnavailable
                            case -1004: error = .wrongHostIP
                            case -1003: error = .wrongHostDNS
                            case -1000: error = .badURL
                            case -1202: error = .invalidRequest
                            default: error = .unknown
                            }
                            handler.change(status: .error(error))
                        } else {
                            handler.change(status: .error(.unknown))
                        }
                    @unknown default:
                        break
                    }
                case "playbackBufferEmpty":
                    handler.startBuffering()
                case "playbackLikelyToKeepUp":
                    handler.endBuffering()
                    handler.change(time: item.currentTime())
                case "playbackBufferFull":
                    handler.endBuffering()
                default:
                    break;
                }
            }
        }
        
    }
    
}

#endif
