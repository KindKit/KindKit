//
//  KindKit
//

import AVFoundation

public extension Device.Video {
    
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

public extension Device.Video {
    
    func supportedFrameDuration() -> [FrameDuration] {
        return self.device.activeFormat.videoSupportedFrameRateRanges.map({
            .init(min: $0.minFrameDuration, max: $0.maxFrameDuration)
        })
    }
    
    func frameDuration() -> FrameDuration {
        return .init(
            min: self.device.activeVideoMinFrameDuration,
            max: self.device.activeVideoMaxFrameDuration
        )
    }
    
}

public extension Device.Video.Configuration {
    
    func supportedFrameDuration() -> [Device.Video.FrameDuration] {
        return self.device.supportedFrameDuration()
    }
    
    func frameDuration() -> Device.Video.FrameDuration {
        return self.device.frameDuration()
    }
    
    func set(frameDuration: Device.Video.FrameDuration) {
        self.device.device.activeVideoMinFrameDuration = frameDuration.min
        self.device.device.activeVideoMaxFrameDuration = frameDuration.max
    }
    
}
