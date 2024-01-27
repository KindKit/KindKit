//
//  KindKit
//

import AVFoundation

public extension VideoDevice {
    
    struct FrameDuration {
        
        public let min: CMTime
        public let max: CMTime
        
        public init(
            min: CMTime,
            max: CMTime
        ) {
            self.min = min
            self.max = max
        }
        
    }
    
}

extension VideoDevice.FrameDuration : Hashable {
}

extension VideoDevice.FrameDuration : Equatable {
}

extension VideoDevice.FrameDuration : Sendable {
}

public extension VideoDevice {
    
    func supportedFrameDuration() -> [FrameDuration] {
        return self.handle.activeFormat.videoSupportedFrameRateRanges.map({
            .init(min: $0.minFrameDuration, max: $0.maxFrameDuration)
        })
    }
    
    func frameDuration() -> FrameDuration {
        return .init(
            min: self.handle.activeVideoMinFrameDuration,
            max: self.handle.activeVideoMaxFrameDuration
        )
    }
    
}

public extension VideoDevice.Configuration {
    
    func supportedFrameDuration() -> [VideoDevice.FrameDuration] {
        return self.device.supportedFrameDuration()
    }
    
    func frameDuration() -> VideoDevice.FrameDuration {
        return self.device.frameDuration()
    }
    
    func set(frameDuration: VideoDevice.FrameDuration) {
        self.device.handle.activeVideoMinFrameDuration = frameDuration.min
        self.device.handle.activeVideoMaxFrameDuration = frameDuration.max
    }
    
}
