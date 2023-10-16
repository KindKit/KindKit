//
//  KindKit
//

import AVFoundation

public extension CameraSession.Recorder {
    
    final class Movie : ICameraSessionRecorder {
        
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
        public var flashMode: CameraSession.Device.Video.Torch
        public let storage: Storage.FileSystem

        private let _output = AVCaptureMovieFileOutput()
        private var _delegate: Delegate?
        private var _context: Context?
        
        public init(
            flashMode: CameraSession.Device.Video.Torch = .off,
            storage: Storage.FileSystem
        ) {
            self.flashMode = flashMode
            self.storage = storage
            self._output.movieFragmentInterval = CMTime.invalid
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
    
    var config: Config {
        return .init(
            maxDuration: self._output.maxRecordedDuration,
            maxFileSize: self._output.maxRecordedFileSize,
            minFreeDiskSpace: self._output.minFreeDiskSpaceLimit
        )
    }
    
    func start(
        config: Config = .init(),
        onSuccess: @escaping (URL) -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        self._start(config, .init(
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
        _ config: Config,
        _ context: Context
    ) {
        guard self.isRecording == false else {
            return
        }
        if self.isAttached == true {
            let delegate = Delegate(recorder: self)
            self._delegate = delegate
            self._context = context
            self._output.maxRecordedDuration = config.maxDuration
            self._output.maxRecordedFileSize = config.maxFileSize
            self._output.minFreeDiskSpaceLimit = config.minFreeDiskSpace
            self._output.startRecording(
                to: self.storage.url(
                    name: UUID().uuidString,
                    extension: "mp4"
                ),
                recordingDelegate: delegate
            )
        } else {
            DispatchQueue.main.async(execute: {
                context.onFailure(.notConneted)
            })
        }
    }
    
}

extension CameraSession.Recorder.Movie {
    
    func finish(_ url: URL) {
        guard let context = self._context else {
            return
        }
        self._delegate = nil
        self._context = nil
        context.onSuccess(url)
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
