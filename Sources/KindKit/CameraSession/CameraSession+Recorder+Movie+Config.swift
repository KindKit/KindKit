//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Movie {
    
    public struct Config {
        
        public let preset: CameraSession.Preset?
        public let flashMode: CameraSession.Device.Video.Torch?
        public let maxDuration: CMTime
        public let maxFileSize: Int64
        public let minFreeDiskSpace: Int64
        
        public init(
            preset: CameraSession.Preset? = nil,
            flashMode: CameraSession.Device.Video.Torch? = nil,
            maxDuration: CMTime = .invalid,
            maxFileSize: Int64 = 0,
            minFreeDiskSpace: Int64 = 0
        ) {
            self.preset = preset
            self.flashMode = flashMode
            self.maxDuration = maxDuration
            self.maxFileSize = maxFileSize
            self.minFreeDiskSpace = minFreeDiskSpace
        }
        
    }
    
}
