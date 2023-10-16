//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Photo {
    
    final class Delegate : NSObject, AVCapturePhotoCaptureDelegate {
        
        weak var recorder: CameraSession.Recorder.Photo?
        
        init(
            recorder: CameraSession.Recorder.Photo
        ) {
            self.recorder = recorder
            super.init()
        }
        
        func photoOutput(
            _ output: AVCapturePhotoOutput,
            didFinishProcessingPhoto photo: AVCapturePhoto,
            error: Swift.Error?
        ) {
            guard let recorder = self.recorder else { return }
            if let error = error {
                recorder.finish(error)
            } else {
                recorder.finish(photo)
            }
        }
        
    }
    
}
