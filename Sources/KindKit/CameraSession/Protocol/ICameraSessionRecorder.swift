//
//  KindKit
//

import AVFoundation

public protocol ICameraSessionRecorder : ICameraSessionOutput, ICancellable {
    
    var isRecording: Bool { get }

}
