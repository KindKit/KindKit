//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Movie {
    
    final class Delegate : NSObject, AVCaptureFileOutputRecordingDelegate {
        
        weak var recorder: CameraSession.Recorder.Movie?
        
        init(
            recorder: CameraSession.Recorder.Movie
        ) {
            self.recorder = recorder
            super.init()
        }
        
        func fileOutput(
            _ output: AVCaptureFileOutput,
            didFinishRecordingTo outputFileURL: URL,
            from connections: [AVCaptureConnection],
            error: Swift.Error?
        ) {
            guard let recorder = self.recorder else { return }
            if let error = error {
                let nsError = error as NSError
                switch nsError.domain {
                case AVFoundationErrorDomain:
                    switch nsError.code {
                    case AVError.Code.maximumDurationReached.rawValue:
                        fallthrough
                    case AVError.Code.maximumFileSizeReached.rawValue:
                        recorder.finish(.init(url: outputFileURL))
                    default:
                        recorder.finish(error)
                    }
                default:
                    recorder.finish(error)
                }
            } else {
                recorder.finish(.init(url: outputFileURL))
            }
        }
        
    }
    
}
