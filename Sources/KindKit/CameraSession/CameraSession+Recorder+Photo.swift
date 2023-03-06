//
//  KindKit
//

import Foundation
import AVFoundation

public extension CameraSession.Recorder {
    
    final class Photo : ICameraSessionRecorder {
        
        public var deviceOrientation: CameraSession.Orientation? {
            didSet {
                guard self.deviceOrientation != oldValue else { return }
                guard let connection = self._output.connection(with: .video) else { return }
                if let videoOrientation = self.deviceOrientation?.avOrientation {
                    connection.videoOrientation = videoOrientation
                } else {
                    connection.videoOrientation = .portrait
                }
            }
        }
        public var interfaceOrientation: CameraSession.Orientation?
        public var output: AVCaptureOutput {
            return self._output
        }
        public var isRecording: Bool {
            return self._delegate != nil && self._context != nil
        }
        @available(macOS 13.0, *)
        public var flash: Flash {
            set { self._settings.flashMode = newValue.raw }
            get { .init(self._settings.flashMode) ?? .off }
        }
        @available(macOS 11.0, *)
        public var supportedFlashes: [Flash] {
            return self._output.supportedFlashModes.compactMap({
                return Flash($0)
            })
        }
        
        private let _settings = AVCapturePhotoSettings()
        private let _output = AVCapturePhotoOutput()
        private var _delegate: Delegate?
        private var _context: Context?

        public init() {
        }
        
        public func cancel() {
            guard self.isRecording == true else { return }
            self._delegate = nil
            self._context = nil
        }
        
    }
    
}

public extension CameraSession.Recorder.Photo {
    
    func start(
        onSuccess: @escaping (UI.Image) -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        self.start(.init(
            onSuccess: onSuccess,
            onFailure: onFailure
        ))
    }
    
}

private extension CameraSession.Recorder.Photo {
    
    func start(_ context: Context) {
        guard self.isRecording == false else {
            return
        }
        if self._output.connections.isEmpty == false {
            let delegate = Delegate(recorder: self)
            self._delegate = delegate
            self._context = context
            self._output.capturePhoto(
                with: self._settings,
                delegate: delegate
            )
        } else {
            DispatchQueue.main.async(execute: {
                context.onFailure(.notConneted)
            })
        }
    }
    
}

extension CameraSession.Recorder.Photo {
    
    func finish(_ photo: AVCapturePhoto) {
        guard let context = self._context else {
            return
        }
        self._delegate = nil
        self._context = nil
        guard let data = photo.fileDataRepresentation() else {
            context.onFailure(.imageRepresentation)
            return
        }
#if os(macOS)
        guard let nsImage = NSImage(data: data) else {
            context.onFailure(.imageRepresentation)
            return
        }
        let image = UI.Image(nsImage)
        context.onSuccess(UI.Image(nsImage))
#elseif os(iOS)
        guard let uiImage = UIImage(data: data) else {
            context.onFailure(.imageRepresentation)
            return
        }
        let image = UI.Image(uiImage)
        context.onSuccess(image.unrotate())
#else
        context.onFailure(.imageRepresentation)
#endif
    }
    
    func finish(_ error: Swift.Error) {
        guard let context = self._context else {
            return
        }
        self._delegate = nil
        self._context = nil
        context.onFailure(.internal(error))
    }

}
