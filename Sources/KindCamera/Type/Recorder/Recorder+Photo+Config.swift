//
//  KindKit
//

import AVFoundation

extension Recorder.Photo {
    
    public struct Config {
        
        public let preset: Device.Video.Preset?
        public let flash: Device.Video.Flash?
#if os(iOS)
        public let rotateToDeviceOrientation: Bool
#endif
        
#if os(iOS)
        public init(
            preset: Device.Video.Preset? = nil,
            flash: Device.Video.Flash? = nil,
            rotateToDeviceOrientation: Bool = true
        ) {
            self.preset = preset
            self.flash = flash
            self.rotateToDeviceOrientation = rotateToDeviceOrientation
        }
#else
        public init(
            preset: Device.Video.Preset? = nil,
            flash: Device.Video.Flash? = nil
        ) {
            self.preset = preset
            self.flash = flash
        }
#endif
        
    }
    
}
