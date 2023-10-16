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
            didStartRecordingTo fileURL: URL,
            from connections: [AVCaptureConnection]
        ) {
            guard let recorder = self.recorder else { return }
            switch recorder.flashMode {
            case .auto, .on:
                guard let session = recorder.session else { return }
                do {
                    try session.configuration({
                        if let videoDevice = session.activeVideoDevice {
                            if videoDevice.isTorchSupported() == true {
                                try videoDevice.configuration({
                                    $0.set(torch: recorder.flashMode)
                                })
                            }
                        }
                    })
                } catch {
                    #warning("Need logging")
                }
            case .off:
                break
            }
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
                        recorder.finish(outputFileURL)
                    default:
                        recorder.finish(error)
                    }
                default:
                    recorder.finish(error)
                }
            } else {
                recorder.finish(outputFileURL)
            }
        }
        
    }
    
}
