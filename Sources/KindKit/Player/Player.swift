//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation

public final class Player {
    
    public private(set) var status: Status = .idle {
        didSet {
            guard self.status != oldValue else { return }
            self.onChangeStatus.emit(self.status)
            switch self.status {
            case .idle, .load, .play, .pause:
                break
            case .ready:
                if self.options.contains(.autoplay) == true {
                    self.play()
                }
            case .finish:
                if self.options.contains(.autorepeat) == true {
                    self.seek(to: self.startTime)
                    self.play()
                }
            case .error:
                break
            }
        }
    }
    public var item: Item? {
        didSet {
            guard self.item != oldValue else { return }
            let playerItem: AVPlayerItem?
            if let item = self.item {
                switch item {
                case .url(let url):
                    playerItem = .init(url: url)
                case .asset(let asset):
                    playerItem = .init(asset: asset)
                }
            } else {
                playerItem = nil
            }
            self._observer.item = playerItem
            self.native.replaceCurrentItem(with: playerItem)
            self.status = .load
        }
    }
    public private(set) var isBuffering: Bool = false {
        didSet {
            guard self.isBuffering != oldValue else { return }
            switch self.isBuffering {
            case true: self.onBeginBuffering.emit()
            case false: self.onEndBuffering.emit()
            }
        }
    }
    public private(set) var isSeeking: Bool = false {
        didSet {
            guard self.isSeeking != oldValue else { return }
            switch self.isSeeking {
            case true: self.onBeginSeeking.emit()
            case false: self.onEndSeeking.emit()
            }
        }
    }
    public var options: Options = []
    public var mute: Bool = false {
        didSet {
            guard self.mute != oldValue else { return }
            self.native.isMuted = self.mute
        }
    }
    public var volume: Double = 1 {
        didSet {
            guard self.volume != oldValue else { return }
            self.native.volume = Float(self.volume)
        }
    }
    public let native: AVPlayer
    
    public let onShouldPlay = Signal.Empty< Bool? >()
    public let onSkip = Signal.Empty< Void >()
    public let onBeginBuffering = Signal.Empty< Void >()
    public let onEndBuffering = Signal.Empty< Void >()
    public let onBeginSeeking = Signal.Empty< Void >()
    public let onEndSeeking = Signal.Empty< Void >()
    public let onChangeStatus = Signal.Args< Void, Status >()
    public let onChangeTime = Signal.Args< Void, CMTime >()
    
    private var _observer: Observer!
    private var _chasingTime: CMTime?
    
    public init() {
        self.native = .init()
        self._observer = Observer(handler: self)
        self._observer.player = self.native
    }
    
}

public extension Player {
    
    var startTime: CMTime {
        guard let item = self.native.currentItem else {
            return CMTime(seconds: 0, preferredTimescale: .init(NSEC_PER_SEC))
        }
        if item.reversePlaybackEndTime.isValid == true {
            return item.reversePlaybackEndTime
        }
        return CMTime(seconds: 0, preferredTimescale: .init(NSEC_PER_SEC))
    }
    
    var currentTime: CMTime {
        guard let item = self.native.currentItem else {
            return CMTime(seconds: 0, preferredTimescale: .init(NSEC_PER_SEC))
        }
        return item.currentTime()
    }
    
    var endTime: CMTime {
        guard let item = self.native.currentItem else {
            return CMTime(seconds: 0, preferredTimescale: .init(NSEC_PER_SEC))
        }
        if item.forwardPlaybackEndTime.isValid == true {
            return item.forwardPlaybackEndTime
        }
        if item.duration.isValid == true && item.duration.isIndefinite == false {
            return item.duration
        }
        return item.currentTime()
    }
    
    @discardableResult
    func play() -> Self {
        switch self.status {
        case .idle, .load, .error:
            break
        case .ready, .play, .pause, .finish:
            if self.shouldPlay() == true {
                self.native.play()
                self.status = .play
            }
        }
        return self
    }
    
    @discardableResult
    func pause() -> Self {
        switch self.status {
        case .idle, .load, .ready, .pause, .finish, .error:
            break
        case .play:
            self.native.pause()
            self.status = .pause
        }
        return self
    }
    
    @discardableResult
    func seek(to time: CMTime) -> Self {
        if self._chasingTime != time {
            self._chasingTime = time
            if self.isSeeking == false {
                self._trySeek()
            }
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func item(_ value: Item) -> Self {
        self.item = value
        return self
    }
    
    @inlinable
    @discardableResult
    func item(_ value: () -> Item) -> Self {
        return self.item(value())
    }
    
    @inlinable
    @discardableResult
    func item(_ value: (Self) -> Item) -> Self {
        return self.item(value(self))
    }
    
    @inlinable
    @discardableResult
    func options(_ value: Options) -> Self {
        self.options = value
        return self
    }
    
    @inlinable
    @discardableResult
    func options(_ value: () -> Options) -> Self {
        return self.options(value())
    }
    
    @inlinable
    @discardableResult
    func options(_ value: (Self) -> Options) -> Self {
        return self.options(value(self))
    }
    
    @inlinable
    @discardableResult
    func mute(_ value: Bool) -> Self {
        self.mute = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mute(_ value: () -> Bool) -> Self {
        return self.mute(value())
    }
    
    @inlinable
    @discardableResult
    func mute(_ value: (Self) -> Bool) -> Self {
        return self.mute(value(self))
    }
    
    @inlinable
    @discardableResult
    func volume(_ value: Double) -> Self {
        self.volume = value
        return self
    }
    
    @inlinable
    @discardableResult
    func volume(_ value: () -> Double) -> Self {
        return self.volume(value())
    }
    
    @inlinable
    @discardableResult
    func volume(_ value: (Self) -> Double) -> Self {
        return self.volume(value(self))
    }
    
    @inlinable
    @discardableResult
    func onShouldPlay(_ closure: (() -> Bool)?) -> Self {
        self.onShouldPlay.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldPlay(_ closure: @escaping (Self) -> Bool) -> Self {
        self.onShouldPlay.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onShouldPlay< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Bool) -> Self {
        self.onShouldPlay.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSkip(_ closure: (() -> Void)?) -> Self {
        self.onSkip.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSkip(_ closure: @escaping (Self) -> Void) -> Self {
        self.onSkip.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSkip< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onSkip.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginBuffering(_ closure: (() -> Void)?) -> Self {
        self.onBeginBuffering.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginBuffering(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginBuffering.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginBuffering< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginBuffering.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndBuffering(_ closure: (() -> Void)?) -> Self {
        self.onEndBuffering.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndBuffering(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndBuffering.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndBuffering< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndBuffering.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginSeeking(_ closure: (() -> Void)?) -> Self {
        self.onBeginSeeking.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginSeeking(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginSeeking.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginSeeking< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginSeeking.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndSeeking(_ closure: (() -> Void)?) -> Self {
        self.onEndSeeking.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndSeeking(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndSeeking.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndSeeking< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndSeeking.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStatus(_ closure: ((Status) -> Void)?) -> Self {
        self.onChangeStatus.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStatus(_ closure: @escaping (Self, Status) -> Void) -> Self {
        self.onChangeStatus.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStatus< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Status) -> Void) -> Self {
        self.onChangeStatus.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeTime(_ closure: ((CMTime) -> Void)?) -> Self {
        self.onChangeTime.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeTime(_ closure: @escaping (Self, CMTime) -> Void) -> Self {
        self.onChangeTime.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeTime< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, CMTime) -> Void) -> Self {
        self.onChangeTime.link(sender, closure)
        return self
    }
    
}

extension Player {
    
    func shouldPlay() -> Bool {
        return self.onShouldPlay.emit() ?? true
    }
    
    func skip() {
        self.onSkip.emit()
    }
    
    func startBuffering() {
        guard self.isBuffering == false else { return }
        self.isBuffering = true
    }
    
    func endBuffering() {
        guard self.isBuffering == true else { return }
        self.isBuffering = false
    }
    
    func change(status: Status) {
        self.status = status
    }
    
    func change(time: CMTime) {
        self.onChangeTime.emit(time)
    }

}

private extension Player {
    
    func _trySeek() {
        switch self.status {
        case .idle, .load, .error:
            break
        case .ready, .play, .pause, .finish:
            guard let time = self._chasingTime else { return }
            self._seek(to: time)
        }
    }
    
    func _seek(to time: CMTime) {
        self.isSeeking = true
        self.native.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] _ in
            guard let self = self, let chasingTime = self._chasingTime else { return }
            self.onChangeTime.emit(self.currentTime)
            if CMTimeCompare(chasingTime, time) == 0 {
                self._chasingTime = nil
                self.isSeeking = false
            } else {
                self._trySeek()
            }
        })
    }
    
}

#endif
