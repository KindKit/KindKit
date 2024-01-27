//
//  KindKit
//

import AVFoundation

extension PhotoRecorder {
    
    final class Delegate : NSObject, AVCapturePhotoCaptureDelegate {
        
        weak var recorder: PhotoRecorder?
        
        init(
            recorder: PhotoRecorder
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
