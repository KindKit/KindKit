//
//  KindKit
//

import Foundation

extension Session {
    
    struct State {
        
        let videoPreset: Device.Video.Preset
        let videoDevice: Device.Video
        let audioDevice: Device.Audio?
        let outputs: [IOutput]
        let recorders: [IRecorder]

    }
    
}
