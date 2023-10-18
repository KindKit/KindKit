//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Photo {
    
    public struct Config {
        
        public let preset: CameraSession.Preset?
        public let flash: Flash?
        
        public init(
            preset: CameraSession.Preset? = nil,
            flash: Flash? = nil
        ) {
            self.preset = preset
            self.flash = flash
        }
        
    }
    
}
