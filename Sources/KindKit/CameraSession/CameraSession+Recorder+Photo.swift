//
//  KindKit
//

import AVFoundation

public extension CameraSession.Recorder {
    
    final class Photo : ICameraSessionRecorder {
        
        public weak var session: CameraSession?
#if os(iOS)
        public var deviceOrientation: CameraSession.Orientation? {
            didSet {
                guard self.deviceOrientation != oldValue else { return }
                if let context = self._context {
                    let orientation = self.resolveOrientation(shouldRotateToDevice: context.config.rotateToDeviceOrientation)
                    self.apply(videoOrientation: orientation)
                }
            }
        }
        public var interfaceOrientation: CameraSession.Orientation? {
            didSet {
                guard self.interfaceOrientation != oldValue else { return }
                if let context = self._context {
                    let orientation = self.resolveOrientation(shouldRotateToDevice: context.config.rotateToDeviceOrientation)
                    self.apply(videoOrientation: orientation)
                }
            }
        }
#endif
        public var output: AVCaptureOutput {
            return self._output
        }
        public var isRecording: Bool {
            return self._delegate != nil && self._context != nil
        }
        public var supportedFlashes: [CameraSession.Device.Video.Flash] {
            if #available(macOS 11.0, iOS 10.0, *) {
                return self._output.supportedFlashModes.compactMap({ .init($0) })
            }
            return [ .off ]
        }
        
        private let _output = AVCapturePhotoOutput()
        private var _delegate: Delegate?
        private var _context: Context?
        private var _restorePreset: CameraSession.Device.Video.Preset?
        private var _restoreFrameDuration: CameraSession.Device.Video.FrameDuration?

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
            self._start(.init(
                config: config,
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
        _ context: Context
    ) {
        guard self.isRecording == false else {
            return
        }
        if let session = self.session {
            if let preset = context.config.preset {
                self._restorePreset = session.activeVideoPreset
                session.configure(
                    videoPreset: preset,
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._start(context, session)
                    }
                )
            } else {
                self._start(context, session)
            }
        } else {
            DispatchQueue.main.async(execute: {
                context.onFailure(.notConneted)
            })
        }
    }
    
    func _start(
        _ context: Context,
        _ session: CameraSession
    ) {
        let delegate = Delegate(recorder: self)
        self._delegate = delegate
        self._context = context
        
#if os(iOS)
        let orientation = self.resolveOrientation(shouldRotateToDevice: context.config.rotateToDeviceOrientation)
        self.apply(videoOrientation: orientation)
#endif

        let settings = AVCapturePhotoSettings()
        if #available(macOS 13.0, *) {
            if let flash = context.config.flash {
                settings.flashMode = flash.raw
            }
        }
        
        self._output.capturePhoto(
            with: settings,
            delegate: delegate
        )
    }
    
    func _restore(_ completion: @escaping () -> Void) {
        guard let session = self.session else { return }
        self._restoreStep1(session: session, completion: completion)
    }
    
    func _restoreStep1(
        session: CameraSession,
        completion: @escaping () -> Void
    ) {
        if let preset = self._restorePreset {
            session.configure(videoPreset: preset, completion: { [weak self] in
                if let self = self {
                    self._restoreStep2(session: session, completion: completion)
                } else {
                    completion()
                }
            })
        } else {
            self._restoreStep2(session: session, completion: completion)
        }
    }
    
    func _restoreStep2(
        session: CameraSession,
        completion: @escaping () -> Void
    ) {
        completion()
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
        guard let nativeImage = NativeImage(data: data) else {
            context.onFailure(.imageRepresentation)
            return
        }
        let image = UI.Image(nativeImage)
        self._restore({
            context.onSuccess(image)
        })
    }
    
    func finish(_ error: Swift.Error) {
        guard let context = self._context else {
            return
        }
        self._delegate = nil
        self._context = nil
        self._restore({
            context.onFailure(.internal(error))
        })
    }

}
