//
//  KindKit
//

import AVFoundation
import CoreMotion

public final class CameraSession {
    
    public let permission: IPermission
    public private(set) var isStarting: Bool = false
    public private(set) var isStarted: Bool = false
#if os(iOS)
    public private(set) var deviceOrientation: CameraSession.Orientation? {
        didSet {
            for recorder in self.activeRecorders {
                recorder.deviceOrientation = self.deviceOrientation
            }
        }
    }
    public private(set) var interfaceOrientation: CameraSession.Orientation? {
        didSet {
            for recorder in self.activeRecorders {
                recorder.interfaceOrientation = self.interfaceOrientation
            }
        }
    }
#endif
    public var videoDevices: [Device.Video] {
        return AVCaptureDevice.DiscoverySession(
            deviceTypes: Device.Video.BuiltIn.allCases.compactMap({ $0.raw }),
            mediaType: .video,
            position: .unspecified
        ).devices.compactMap({
            Device.Video($0)
        })
    }
    public var audioDevices: [Device.Audio] {
        return AVCaptureDevice.DiscoverySession(
            deviceTypes: [ .builtInMicrophone ],
            mediaType: .audio,
            position: .unspecified
        ).devices.compactMap({
            Device.Audio($0)
        })
    }
    public var activeVideoPreset: Preset? {
        return self._activeState?.videoPreset
    }
    public var activeVideoDevice: Device.Video? {
        return self._activeState?.videoDevice
    }
    public var activeAudioDevice: Device.Audio? {
        return self._activeState?.audioDevice
    }
    public var activeRecorders: [ICameraSessionRecorder] {
        return self._activeState?.recorders ?? []
    }

    public let session = AVCaptureSession()
#if os(iOS)
    public let motionManager = CMMotionManager()
#endif
    
    private var _startState: State?
    private var _activeState: State?
    private var _queue = DispatchQueue(label: "KindKit.CameraSession")
    private let _observer = Observer< ICameraSessionObserver >()
    private var _captureSessionStartObserver: NSObjectProtocol?
    private var _captureSessionStopObserver: NSObjectProtocol?
    
    public init(
        _ permission: IPermission
    ) {
        self.permission = permission
        self._setup()
    }
    
    deinit {
        self._destroy()
        self.stop()
    }
    
}

private extension CameraSession {
    
    func _setup() {
#if os(iOS)
        self.motionManager.accelerometerUpdateInterval = 0.1
#endif
        self.permission.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self.permission.remove(observer: self)
    }
    
    func _subscribeSession() {
        self._captureSessionStartObserver = NotificationCenter.default.addObserver(
            forName: .AVCaptureSessionDidStartRunning,
            object: self.session,
            queue: OperationQueue.main,
            using: { [weak self] _ in self?._didStart() }
        )
        self._captureSessionStopObserver = NotificationCenter.default.addObserver(
            forName: .AVCaptureSessionDidStopRunning,
            object: self.session,
            queue: OperationQueue.main,
            using: { [weak self] _ in self?._didStop() }
        )
#if os(iOS)
        self._subscribeDeviceOrientaion()
#endif
    }

    func _unsubscribeSession() {
#if os(iOS)
        self._unsubscribeDeviceOrientaion()
#endif
        if let observer = self._captureSessionStopObserver {
            NotificationCenter.default.removeObserver(observer)
            self._captureSessionStopObserver = nil
        }
        if let observer = self._captureSessionStartObserver {
            NotificationCenter.default.removeObserver(observer)
            self._captureSessionStartObserver = nil
        }
    }
    
#if os(iOS)
    
    func _set(deviceOrientation: Orientation?) {
        if self.deviceOrientation != deviceOrientation {
            self.deviceOrientation = deviceOrientation
            self._observer.notify({ $0.changed(self, deviceOrientation: deviceOrientation) })
        }
    }
    
    func _set(interfaceOrientation: Orientation?) {
        if self.interfaceOrientation != interfaceOrientation {
            self.interfaceOrientation = interfaceOrientation
            self._observer.notify({ $0.changed(self, interfaceOrientation: interfaceOrientation) })
        }
    }
    
    func _currentUnterfaceOrientation() -> Orientation? {
        if #available(iOS 16.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                guard let scene = scene as? UIWindowScene else { continue }
                return .init(scene.effectiveGeometry.interfaceOrientation)
            }
            return nil
        } else {
            return .init(UIApplication.shared.statusBarOrientation)
        }
    }
    
    func _subscribeDeviceOrientaion() {
        self._set(deviceOrientation: .init(UIDevice.current.orientation))
        self._set(interfaceOrientation: self._currentUnterfaceOrientation())
        self.motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else {
                return
            }
            self?._handleAccelerometer(data: data)
        }
    }
  
    func _unsubscribeDeviceOrientaion() {
        self.motionManager.stopAccelerometerUpdates()
        self._set(deviceOrientation: nil)
    }
    
#endif

    func _start(
        _ state: State
    ) {
        switch self.permission.status {
        case .notSupported:
            return
        case .notDetermined:
            self._startState = state
            self.permission.request(source: self)
        case .authorized:
            self._configure(state: state)
        case .denied:
            self._startState = state
        }
    }
    
    func _configure(
        state: State
    ) {
        self._configure(
            old: self._activeState,
            new: state,
            didConfigure: {
                self._subscribeSession()
            }
        )
    }
    
    func _configure(
        old: State?,
        new: State,
        willConfigure: (() -> Void)? = nil,
        didConfigure: (() -> Void)? = nil,
        didStart: (() -> Void)? = nil
    ) {
        self._queue.async(execute: { [weak self] in
            guard let self = self else { return }
            if let willConfigure = willConfigure {
                DispatchQueue.main.sync(execute: willConfigure)
            }
            self.session.beginConfiguration()
            if old?.videoPreset != new.videoPreset {
                let raw = new.videoPreset.raw
                if self.session.canSetSessionPreset(raw) == true {
                    self.session.sessionPreset = raw
                } else {
                    self.session.sessionPreset = .high
                }
            }
            if old?.videoDevice !== new.videoDevice {
                if let videoDevice = old?.videoDevice {
                    self.session.removeInput(videoDevice.input)
                }
                if self.session.canAddInput(new.videoDevice.input) == true {
                    self.session.addInput(new.videoDevice.input)
                }
            }
            if old?.audioDevice !== new.audioDevice {
                if let audioDevice = old?.audioDevice {
                    self.session.removeInput(audioDevice.input)
                }
                if let audioDevice = new.audioDevice {
                    if self.session.canAddInput(audioDevice.input) == true {
                        self.session.addInput(audioDevice.input)
                    }
                }
            }
            if let oldRecorders = old?.recorders {
                do {
                    let recorders = oldRecorders.filter({ recorder in
                        return new.recorders.contains(where: { $0 === recorder }) == false
                    })
                    for recorder in recorders {
                        self.session.removeOutput(recorder.output)
                    }
                }
                do {
                    let recorders = new.recorders.filter({ recorder in
                        return oldRecorders.contains(where: { $0 === recorder }) == false
                    })
                    for recorder in recorders {
                        if self.session.canAddOutput(recorder.output) == true {
                            self.session.addOutput(recorder.output)
                        }
                    }
                }
            } else {
                for recorder in new.recorders {
                    if self.session.canAddOutput(recorder.output) == true {
                        self.session.addOutput(recorder.output)
                    }
                }
            }
            self.session.commitConfiguration()
            DispatchQueue.main.sync(execute: {
                self._activeState = new
            })
            if let didConfigure = didConfigure {
                DispatchQueue.main.sync(execute: didConfigure)
            }
            self.session.startRunning()
            DispatchQueue.main.sync(execute: {
                didStart?()
            })
        })
    }
    
    func _didStart() {
        self.isStarted = true
        self._observer.notify({ $0.started(self) })
    }

    func _didStop() {
        self.isStarted = false
        self._observer.notify({ $0.stopped(self) })
    }
    
    func _set(
        videoPreset: Preset? = nil,
        videoDevice: Device.Video? = nil,
        audioDevice: Device.Audio? = nil,
        recorders: [ICameraSessionRecorder]? = nil
    ) {
        guard let activeState = self._activeState else {
            return
        }
        if let videoPreset = videoPreset, let videoDevice = videoDevice {
            if videoDevice.isPresetSupported(videoPreset) == false {
                return
            }
        }
        self._configure(
            old: activeState,
            new: .init(
                videoPreset: videoPreset ?? activeState.videoPreset,
                videoDevice: videoDevice ?? activeState.videoDevice,
                audioDevice: audioDevice ?? activeState.audioDevice,
                recorders: recorders ?? activeState.recorders
            ),
            willConfigure: {
                self._unsubscribeSession()
                self.session.stopRunning()
                self._observer.notify({ $0.startConfiguration(self) })
            },
            didStart: {
                self._subscribeSession()
                self._observer.notify({ $0.finishConfiguration(self) })
            }
        )
    }
    
#if os(iOS)
    
    func _handleAccelerometer(data: CMAccelerometerData) {
        if abs(data.acceleration.y) < abs(data.acceleration.x) {
            if data.acceleration.x > 0 {
                self._set(deviceOrientation: .landscapeRight)
            } else {
                self._set(deviceOrientation: .landscapeLeft)
            }
        } else {
            if data.acceleration.y > 0 {
                self._set(deviceOrientation: .portraitUpsideDown)
            } else {
                self._set(deviceOrientation: .portrait)
            }
        }
        self._set(interfaceOrientation: self._currentUnterfaceOrientation())
    }
    
#endif

}

public extension CameraSession {
    
    func add(observer: ICameraSessionObserver, priority: ObserverPriority) {
        self._observer.add(observer, priority: priority)
    }
    
    func remove(observer: ICameraSessionObserver) {
        self._observer.remove(observer)
    }
    
}

public extension CameraSession {

    func start(
        video: Discovery.Video,
        audio: Device.Audio? = nil,
        recorders: [ICameraSessionRecorder] = []
    ) {
        self.start(
            videoPreset: video.preset,
            videoDevice: video.device,
            audioDevice: audio,
            recorders: recorders
        )
    }
    
    func start(
        videoPreset: Preset,
        videoDevice: Device.Video,
        audioDevice: Device.Audio? = nil,
        recorders: [ICameraSessionRecorder] = []
    ) {
        guard self.isStarting == false && self.isStarted == false else {
            return
        }
        self.isStarting = true
        self._start(.init(
            videoPreset: videoPreset,
            videoDevice: videoDevice,
            audioDevice: audioDevice,
            recorders: recorders
        ))
    }
    
    func stop() {
        if self.isStarted == true {
            self._queue.async(execute: { [weak self] in
                guard let self = self else { return }
                self.session.stopRunning()
            })
            self._activeState = nil
        }
        self.isStarting = false
    }
    
    func set(
        videoPreset: Preset,
        videoDevice: Device.Video,
        audioDevice: Device.Audio,
        recorders: [ICameraSessionRecorder]
    ) {
        self._set(
            videoPreset: videoPreset,
            videoDevice: videoDevice,
            audioDevice: audioDevice,
            recorders: recorders
        )
    }
    
    func set(
        video: Discovery.Video
    ) {
        self.set(
            preset: video.preset,
            device: video.device
        )
    }
    
    func set(
        preset: Preset,
        device: Device.Video
    ) {
        return self._set(
            videoPreset: preset,
            videoDevice: device
        )
    }
    
    func set(
        device: Device.Audio
    ) {
        return self._set(audioDevice: device)
    }
    
    func set(
        recorders: [ICameraSessionRecorder]
    ) {
        return self._set(
            recorders: recorders
        )
    }
    
}

extension CameraSession : IPermissionObserver {
    
    public func didRedirectToSettings(_ permission: IPermission, source: Any?) {
    }
    
    public func willRequest(_ permission: IPermission, source: Any?) {
    }
    
    public func didRequest(_ permission: IPermission, source: Any?) {
        if self.permission === permission {
            switch self.permission.status {
            case .authorized:
                if self.isStarting == true {
                    if let state = self._startState {
                        self._startState = nil
                        self._configure(state: state)
                    }
                }
            default:
                if self.isStarting == true {
                    self._activeState = nil
                    self.isStarting = false
                } else if self.isStarted == true {
                    self.stop()
                }
            }
        }
    }
    
}
