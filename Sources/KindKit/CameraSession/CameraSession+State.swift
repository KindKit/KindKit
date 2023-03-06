//
//  KindKit
//

import Foundation

extension CameraSession {
    
    struct State {
        
        let videoPreset: Preset
        let videoDevice: Device.Video
        let audioDevice: Device.Audio?
        let recorders: [ICameraSessionRecorder]

    }
    
}
