//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Photo {
    
    public struct Config {
        
        public let preset: CameraSession.Device.Video.Preset?
        public let flash: CameraSession.Device.Video.Flash?
#if os(iOS)
        public let rotateToDeviceOrientation: Bool
#endif
        
#if os(iOS)
        public init(
            preset: CameraSession.Device.Video.Preset? = nil,
            flash: CameraSession.Device.Video.Flash? = nil,
            rotateToDeviceOrientation: Bool = true
        ) {
            self.preset = preset
            self.flash = flash
            self.rotateToDeviceOrientation = rotateToDeviceOrientation
        }
#else
        public init(
            preset: CameraSession.Device.Video.Preset? = nil,
            flash: CameraSession.Device.Video.Flash? = nil
        ) {
            self.preset = preset
            self.flash = flash
        }
#endif
        
    }
    
}
