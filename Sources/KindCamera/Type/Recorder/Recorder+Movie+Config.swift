//
//  KindKit
//

import AVFoundation

extension Recorder.Movie {
    
    public struct Config {
        
        public let preset: Device.Video.Preset?
        public let codec: Recorder.Movie.Codec?
        public let flashMode: Device.Video.Torch?
#if os(iOS)
        public let stabilizationMode: Device.Video.StabilizationMode?
        public let rotateToDeviceOrientation: Bool
#endif
        public let frameDuration: Device.Video.FrameDuration?
        public let averageBitRate: UInt?
        public let maxDuration: CMTime
        public let maxFileSize: Int64
        public let minFreeDiskSpace: Int64
        
#if os(macOS)
        
        public init(
            preset: Device.Video.Preset? = nil,
            codec: Recorder.Movie.Codec? = nil,
            flashMode: Device.Video.Torch? = nil,
            frameDuration: Device.Video.FrameDuration? = nil,
            averageBitRate: UInt? = nil,
            maxDuration: CMTime = .invalid,
            maxFileSize: Int64 = 0,
            minFreeDiskSpace: Int64 = 0
        ) {
            self.preset = preset
            self.codec = codec
            self.flashMode = flashMode
            self.frameDuration = frameDuration
            self.averageBitRate = averageBitRate
            self.maxDuration = maxDuration
            self.maxFileSize = maxFileSize
            self.minFreeDiskSpace = minFreeDiskSpace
        }
        
#elseif os(iOS)
        
        public init(
            preset: Device.Video.Preset? = nil,
            codec: Recorder.Movie.Codec? = nil,
            flashMode: Device.Video.Torch? = nil,
            stabilizationMode: Device.Video.StabilizationMode? = nil,
            rotateToDeviceOrientation: Bool = true,
            frameDuration: Device.Video.FrameDuration? = nil,
            averageBitRate: UInt? = nil,
            maxDuration: CMTime = .invalid,
            maxFileSize: Int64 = 0,
            minFreeDiskSpace: Int64 = 0
        ) {
            self.preset = preset
            self.codec = codec
            self.flashMode = flashMode
            self.stabilizationMode = stabilizationMode
            self.rotateToDeviceOrientation = rotateToDeviceOrientation
            self.frameDuration = frameDuration
            self.averageBitRate = averageBitRate
            self.maxDuration = maxDuration
            self.maxFileSize = maxFileSize
            self.minFreeDiskSpace = minFreeDiskSpace
        }
        
#endif
        
    }
    
}

extension Recorder.Movie.Config {
    
    var shouldConfigure: Bool {
        return self.preset != nil || self.frameDuration != nil
    }
    
}
