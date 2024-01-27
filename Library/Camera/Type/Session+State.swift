//
//  KindKit
//

extension Session {
    
    struct State {
        
        let videoPreset: VideoDevice.Preset
        let videoDevice: VideoDevice
        let audioDevice: AudioDevice?
        let outputs: [Output]
        let recorders: [Recorder]

    }
    
}

extension Session.State : Sendable {
}
