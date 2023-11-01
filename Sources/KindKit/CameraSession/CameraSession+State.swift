//
//  KindKit
//

import Foundation

extension CameraSession {
    
    struct State {
        
        let videoPreset: Device.Video.Preset
        let videoDevice: Device.Video
        let audioDevice: Device.Audio?
        let recorders: [ICameraSessionRecorder]

    }
    
}
