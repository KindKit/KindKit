//
//  KindKit
//

import AVFoundation

extension PhotoRecorder {
    
    public struct Config {
        
        public let preset: VideoDevice.Preset?
        public let flash: VideoDevice.Flash?
#if os(iOS)
        public let rotateToDeviceOrientation: Bool
#endif
        
#if os(iOS)
        public init(
            preset: VideoDevice.Preset? = nil,
            flash: VideoDevice.Flash? = nil,
            rotateToDeviceOrientation: Bool = true
        ) {
            self.preset = preset
            self.flash = flash
            self.rotateToDeviceOrientation = rotateToDeviceOrientation
        }
#else
        public init(
            preset: VideoDevice.Preset? = nil,
            flash: VideoDevice.Flash? = nil
        ) {
            self.preset = preset
            self.flash = flash
        }
#endif
        
    }
    
}

extension PhotoRecorder.Config : Hashable {
}

extension PhotoRecorder.Config : Equatable {
}

extension PhotoRecorder.Config : Sendable {
}
