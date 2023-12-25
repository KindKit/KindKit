//
//  KindKit
//

import AVFoundation

public extension CameraSession.Recorder {
    
    final class Movie : ICameraSessionRecorder {
        
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
        public let storage: Storage.FileSystem
        public var supportedCodecs: [Codec] {
#if os(macOS)
            return [ .hevc, .h264 ]
#elseif os(iOS)
            return self._output.availableVideoCodecTypes.compactMap({ .init($0) })
#endif
        }

        private let _output = AVCaptureMovieFileOutput()
        private var _delegate: Delegate?
        private var _context: Context?
        private var _restorePreset: CameraSession.Device.Video.Preset?
        private var _restoreFrameDuration: CameraSession.Device.Video.FrameDuration?
        private var _restoreFlashMode: CameraSession.Device.Video.Torch?

        public init(
            storage: Storage.FileSystem
        ) {
            self.storage = storage
            self._output.movieFragmentInterval = .invalid
        }
        
        public func attach(session: CameraSession) {
            guard self.isAttached == false else { return }
            self.session = session
        }
        
        public func detach() {
            guard self.isAttached == true else { return }
            self.session = nil
        }
        
        public func cancel() {
            guard self.isRecording == true else { return }
            self._delegate = nil
            self._context = nil
        }
        
    }
    
}

public extension CameraSession.Recorder.Movie {
    
    var recordedDuration: CMTime {
        return self._output.recordedDuration
    }
    
    var recordedFileSize: Int64 {
        return self._output.recordedFileSize
    }
    
    func start(
        config: Config = .init(),
        onSuccess: @escaping (TemporaryFile) -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        self._start(.init(
            config: config,
            onSuccess: onSuccess,
            onFailure: onFailure
        ))
    }
    
    func stop() {
        guard self.isRecording == true else {
            return
        }
        self._output.stopRecording()
    }
    
}

private extension CameraSession.Recorder.Movie {
    
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
        
        if let connection = self.videoConnection {
            var settings: [String : Any] = [:]
            var compressionProperties: [String : Any] = [:]
            if let codec = context.config.codec {
                if self.supportedCodecs.contains(codec) == true {
                    settings[AVVideoCodecKey] = codec.raw
                } else {
#if DEBUG
                    fatalError("Not supported codec type \(codec)")
#endif
                }
            }
            if let averageBitRate = context.config.averageBitRate {
                compressionProperties[AVVideoAverageBitRateKey] = NSNumber(value: averageBitRate)
            }
            if compressionProperties.isEmpty == false {
                settings[AVVideoCompressionPropertiesKey] = compressionProperties
            }
            if settings.isEmpty == false {
                self._output.setOutputSettings(settings, for: connection)
            }
#if os(iOS)
            if let stabilizationMode = context.config.stabilizationMode {
                connection.preferredVideoStabilizationMode = stabilizationMode.raw
            }
            if context.config.rotateToDeviceOrientation == true {
                self._output.setRecordsVideoOrientationAndMirroringChangesAsMetadataTrack(true, for: connection)
            }
#endif
        }
        self._output.maxRecordedDuration = context.config.maxDuration
        self._output.maxRecordedFileSize = context.config.maxFileSize
        self._output.startRecording(
            to: self.storage.url(name: UUID().uuidString, extension: "mp4"),
            recordingDelegate: delegate
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
        if self._restoreFrameDuration != nil || self._restoreFlashMode != nil {
            if let device = session.activeVideoDevice {
                device.configuration({
                    if let frameDuration = self._restoreFrameDuration {
                        $0.set(frameDuration: frameDuration)
                    }
                    if let flashMode = self._restoreFlashMode {
                        if $0.isTorchSupported() == true {
                            $0.set(torch: flashMode)
                        }
                    }
                })
            }
        }
        self._restoreStep3(session: session, completion: completion)
    }
    
    func _restoreStep3(
        session: CameraSession,
        completion: @escaping () -> Void
    ) {
        completion()
    }
    
}

extension CameraSession.Recorder.Movie {
    
    func started() {
        guard let device = self.session?.activeVideoDevice else { return }
        guard let context = self._context else { return }
        if context.config.flashMode != nil {
            device.configuration({
                if let frameDuration = context.config.frameDuration {
                    self._restoreFrameDuration = $0.frameDuration()
                    $0.set(frameDuration: frameDuration)
                }
                if let flashMode = context.config.flashMode {
                    if $0.isTorchSupported() == true {
                        self._restoreFlashMode = $0.torch()
                        $0.set(torch: flashMode)
                    }
                }
            })
        }
    }
    
    func finish(_ url: TemporaryFile) {
        guard let context = self._context else {
            return
        }
        self._delegate = nil
        self._context = nil
        self._restore({
            context.onSuccess(url)
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
