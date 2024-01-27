//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation
import KindEvent
import KindMeasure
import KindMonadicMacro

@Monadic
@MainActor
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
    
    @MonadicField
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
    
    @MonadicField
    public var options: Options = []
    
    @MonadicField
    public var mute: Bool = false {
        didSet {
            guard self.mute != oldValue else { return }
            self.native.isMuted = self.mute
        }
    }
    
    @MonadicField
    public var volume: Double = 1 {
        didSet {
            guard self.volume != oldValue else { return }
            self.native.volume = Float(self.volume)
        }
    }
    public let native: AVPlayer
    
    @MonadicSignal
    public let onShouldPlay = Signal< Bool?, Void >()
    
    @MonadicSignal
    public let onSkip = Signal< Void, Void >()
    
    @MonadicSignal
    public let onBeginBuffering = Signal< Void, Void >()
    
    @MonadicSignal
    public let onEndBuffering = Signal< Void, Void >()
    
    @MonadicSignal
    public let onBeginSeeking = Signal< Void, Void >()
    
    @MonadicSignal
    public let onEndSeeking = Signal< Void, Void >()
    
    @MonadicSignal
    public let onChangeStatus = Signal< Void, Status >()
    
    @MonadicSignal
    public let onChangeTime = Signal< Void, Time >()
    
    private var _observer: Observer!
    private var _chasingTime: Time?
    
    public init() {
        self.native = .init()
        self._observer = Observer(handler: self)
        self._observer.player = self.native
    }
    
}

extension Player : @unchecked Sendable {
}

public extension Player {
    
    var startTime: Time {
        guard let item = self.native.currentItem else {
            return .zero
        }
        if item.reversePlaybackEndTime.isValid == true {
            return .init(cmTime: item.reversePlaybackEndTime)
        }
        return .zero
    }
    
    var currentTime: Time {
        guard let item = self.native.currentItem else {
            return .zero
        }
        return .init(cmTime: item.currentTime())
    }
    
    var endTime: Time {
        guard let item = self.native.currentItem else {
            return .zero
        }
        if item.forwardPlaybackEndTime.isValid == true {
            return .init(cmTime: item.forwardPlaybackEndTime)
        }
        if item.duration.isValid == true && item.duration.isIndefinite == false {
            return .init(cmTime: item.duration)
        }
        return .init(cmTime: item.currentTime())
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
    func seek(to time: Time) -> Self {
        if self._chasingTime != time {
            self._chasingTime = time
            if self.isSeeking == false {
                self._trySeek()
            }
        }
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
    
    func change(time: Time) {
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
    
    func _seek(to time: Time) {
        Task(operation: {
            self.isSeeking = true
            await self.native.seek(to: time.cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
            guard let chasingTime = self._chasingTime else { return }
            self.onChangeTime.emit(self.currentTime)
            if chasingTime == time {
                self._chasingTime = nil
                self.isSeeking = false
            } else {
                self._trySeek()
            }
        })
    }
    
}

#endif
