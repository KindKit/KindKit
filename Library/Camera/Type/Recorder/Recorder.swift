//
//  KindKit
//

import AVFoundation
import KindCore

public protocol Recorder : Output, CancelTrait {
    
    var isRecording: Bool { get }

}
