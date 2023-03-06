//
//  KindKit
//

import Foundation
import AVFoundation

public extension CameraSession.Device.Video {
    
    func isPresetSupported(_ preset: CameraSession.Preset) -> Bool {
        return self.device.supportsSessionPreset(preset.raw)
    }
    
}
