//
//  KindKit
//

import AVFoundation

public extension CameraSession.Output {
    
    final class Frame : ICameraSessionOutput {
        
        public weak var session: CameraSession?
#if os(iOS)
        public var deviceOrientation: CameraSession.Orientation? {
            didSet {
                guard self.deviceOrientation != oldValue else { return }
                let orientation = self.resolveOrientation(shouldRotateToDevice: self.rotateToDeviceOrientation)
                self.apply(videoOrientation: orientation)
            }
        }
        public var interfaceOrientation: CameraSession.Orientation? {
            didSet {
                guard self.interfaceOrientation != oldValue else { return }
                let orientation = self.resolveOrientation(shouldRotateToDevice: self.rotateToDeviceOrientation)
                self.apply(videoOrientation: orientation)
            }
        }
#endif
        public var output: AVCaptureOutput {
            return self._output
        }
        public var rotateToDeviceOrientation: Bool {
            didSet {
                guard self.rotateToDeviceOrientation != oldValue else { return }
                let orientation = self.resolveOrientation(shouldRotateToDevice: self.rotateToDeviceOrientation)
                self.apply(videoOrientation: orientation)
            }
        }
        public private(set) var frame: UI.Image? {
            didSet {
                guard self.frame != oldValue else { return }
                if let frame = self.frame {
                    self.onFrame.emit(frame)
                }
            }
        }
        public let onFrame = Signal.Args< Void, UI.Image >()
        
        private lazy var _output = {
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA ]
            output.setSampleBufferDelegate(self._delegate, queue: self._workQueue)
            return output
        }()
        private lazy var _delegate = Delegate(output: self)
        private let _workQueue = DispatchQueue(label: "KindKit.CameraSession.Output.Frame")
        private let _syncQueue: DispatchQueue

        public init(
            rotateToDeviceOrientation: Bool = true,
            queue: DispatchQueue = .main
        ) {
            self.rotateToDeviceOrientation = rotateToDeviceOrientation
            self._syncQueue = queue
        }
        
        public func attach(session: CameraSession) {
            guard self.isAttached == false else { return }
            self.session = session
        }
        
        public func detach() {
            guard self.isAttached == true else { return }
            self.session = nil
        }
        
    }
    
}

extension CameraSession.Output.Frame {
    
    func frame(_ image: UI.Image) {
        self._syncQueue.async(execute: { [weak self] in
            self?.frame = image
        })
    }
    
}
