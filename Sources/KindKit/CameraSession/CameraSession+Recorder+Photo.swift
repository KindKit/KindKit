//
//  KindKit
//

import AVFoundation

public extension CameraSession.Recorder {
    
    final class Photo : ICameraSessionRecorder {
        
        public weak var session: CameraSession?
        public var deviceOrientation: CameraSession.Orientation?
        public var interfaceOrientation: CameraSession.Orientation? {
            didSet {
                guard self.interfaceOrientation != oldValue else { return }
                guard let connection = self._output.connection(with: .video) else { return }
                if let videoOrientation = self.interfaceOrientation?.avOrientation {
                    connection.videoOrientation = videoOrientation
                } else {
                    connection.videoOrientation = .portrait
                }
            }
        }
        public var output: AVCaptureOutput {
            return self._output
        }
        public var isRecording: Bool {
            return self._delegate != nil && self._context != nil
        }
        @available(macOS 11.0, *)
        public var supportedFlashes: [Flash] {
            return self._output.supportedFlashModes.compactMap({
                return Flash($0)
            })
        }
        
        private let _output = AVCapturePhotoOutput()
        private var _delegate: Delegate?
        private var _context: Context?

        public init() {
        }
        
        public func attach(session: CameraSession) {
            guard self.isAttached == false else { return }
            self.session = session
        }
        
        public func detach() {
            guard self.isAttached == true else { return }
            self.session = nil
        }
        
        public func start(
            config: Config = .init(),
            onSuccess: @escaping (UI.Image) -> Void,
            onFailure: @escaping (Error) -> Void
        ) {
            self._start(config, .init(
                onSuccess: onSuccess,
                onFailure: onFailure
            ))
        }
        
        public func cancel() {
            guard self.isRecording == true else { return }
            self._delegate = nil
            self._context = nil
        }
        
    }
    
}

private extension CameraSession.Recorder.Photo {
    
    func _start(
        _ config: Config,
        _ context: Context
    ) {
        guard self.isRecording == false else {
            return
        }
        if let session = self.session {
            if let preset = config.preset {
                session.configure(
                    videoPreset: preset,
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._start(config, context, session)
                    }
                )
            } else {
                self._start(config, context, session)
            }
        } else {
            DispatchQueue.main.async(execute: {
                context.onFailure(.notConneted)
            })
        }
    }
    
    func _start(
        _ config: Config,
        _ context: Context,
        _ session: CameraSession
    ) {
        let delegate = Delegate(recorder: self)
        self._delegate = delegate
        self._context = context
        
        let settings = AVCapturePhotoSettings()
        if #available(macOS 13.0, *) {
            if let flash = config.flash {
                settings.flashMode = flash.raw
            }
        }
        
        self._output.capturePhoto(
            with: settings,
            delegate: delegate
        )
    }
    
#if os(iOS)
    
    func _image(_ data: Data) -> UIImage? {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        guard let cgImage = uiImage.cgImage else {
            return nil
        }
        let oldOrientation = uiImage.imageOrientation
        let isMirrored: Bool
        switch oldOrientation {
        case .rightMirrored, .leftMirrored, .upMirrored, .downMirrored:
            isMirrored = true
        default:
            isMirrored = false
        }
        let newOrientation: UIImage.Orientation
        switch self.deviceOrientation {
        case .landscapeLeft:
            newOrientation = isMirrored == true ? .upMirrored : .up
        case .landscapeRight:
            newOrientation = isMirrored == true ? .downMirrored : .down
        default:
            newOrientation = isMirrored == true ? .leftMirrored : .right
        }
        if oldOrientation != newOrientation {
            return UIImage(cgImage: cgImage, scale: uiImage.scale, orientation: newOrientation)
        }
        return uiImage
    }
    
#endif
    
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
        context.onSuccess(image)
#elseif os(iOS)
        guard let uiImage = self._image(data) else {
            context.onFailure(.imageRepresentation)
            return
        }
        let originImage = UI.Image(uiImage)
        let unrotateImage = originImage.unrotate()
        context.onSuccess(unrotateImage)
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
