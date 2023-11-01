//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Movie {
    
    public struct Config {
        
        public let preset: CameraSession.Device.Video.Preset?
        public let codec: CameraSession.Recorder.Movie.Codec?
        public let flashMode: CameraSession.Device.Video.Torch?
#if os(iOS)
        public let stabilizationMode: CameraSession.Device.Video.StabilizationMode?
        public let rotateToDeviceOrientation: Bool
#endif
        public let maxDuration: CMTime
        public let maxFileSize: Int64
        public let minFreeDiskSpace: Int64
        
#if os(macOS)
        
        public init(
            preset: CameraSession.Device.Video.Preset? = nil,
            codec: CameraSession.Recorder.Movie.Codec? = nil,
            flashMode: CameraSession.Device.Video.Torch? = nil,
            maxDuration: CMTime = .invalid,
            maxFileSize: Int64 = 0,
            minFreeDiskSpace: Int64 = 0
        ) {
            self.preset = preset
            self.codec = codec
            self.flashMode = flashMode
            self.maxDuration = maxDuration
            self.maxFileSize = maxFileSize
            self.minFreeDiskSpace = minFreeDiskSpace
        }
        
#elseif os(iOS)
        
        public init(
            preset: CameraSession.Device.Video.Preset? = nil,
            codec: CameraSession.Recorder.Movie.Codec? = nil,
            flashMode: CameraSession.Device.Video.Torch? = nil,
            stabilizationMode: CameraSession.Device.Video.StabilizationMode? = nil,
            rotateToDeviceOrientation: Bool = true,
            maxDuration: CMTime = .invalid,
            maxFileSize: Int64 = 0,
            minFreeDiskSpace: Int64 = 0
        ) {
            self.preset = preset
            self.codec = codec
            self.flashMode = flashMode
            self.stabilizationMode = stabilizationMode
            self.rotateToDeviceOrientation = rotateToDeviceOrientation
            self.maxDuration = maxDuration
            self.maxFileSize = maxFileSize
            self.minFreeDiskSpace = minFreeDiskSpace
        }
        
#endif
        
    }
    
}
