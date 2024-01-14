//
//  KindKit
//

import AVFoundation

public protocol IRecorder : IOutput, ICancellable {
    
    var isRecording: Bool { get }

}
