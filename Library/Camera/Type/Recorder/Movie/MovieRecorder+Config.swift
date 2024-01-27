//
//  KindKit
//

import AVFoundation

extension MovieRecorder {
    
    public struct Config {
        
        public let preset: VideoDevice.Preset?
        public let codec: MovieRecorder.Codec?
        public let flashMode: VideoDevice.Torch?
#if os(iOS)
        public let stabilizationMode: VideoDevice.StabilizationMode?
        public let rotateToDeviceOrientation: Bool
#endif
        public let frameDuration: VideoDevice.FrameDuration?
        public let averageBitRate: UInt?
        public let maxDuration: CMTime
        public let maxFileSize: Int64
        public let minFreeDiskSpace: Int64
        
#if os(macOS)
        
        public init(
            preset: VideoDevice.Preset? = nil,
            codec: MovieRecorder.Codec? = nil,
            flashMode: VideoDevice.Torch? = nil,
            frameDuration: VideoDevice.FrameDuration? = nil,
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
            preset: VideoDevice.Preset? = nil,
            codec: MovieRecorder.Codec? = nil,
            flashMode: VideoDevice.Torch? = nil,
            stabilizationMode: VideoDevice.StabilizationMode? = nil,
            rotateToDeviceOrientation: Bool = true,
            frameDuration: VideoDevice.FrameDuration? = nil,
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

extension MovieRecorder.Config {
    
    var shouldConfigure: Bool {
        return self.preset != nil || self.frameDuration != nil
    }
    
}

extension MovieRecorder.Config : Sendable {
}
