//
//  KindKit
//

@preconcurrency import AVFoundation
@preconcurrency import CoreMotion
#if os(iOS)
import UIKit
#endif
import KindEvent
import KindMonadicMacro

@Monadic
public final class Session {
    
    public private(set) var isStarting: Bool = false
    
    public private(set) var isStarted: Bool = false
    
#if os(iOS)
    
    public private(set) var deviceOrientation: Orientation? {
        didSet {
            for recorder in self.activeRecorders {
                recorder.deviceOrientation = self.deviceOrientation
            }
        }
    }
    
    public private(set) var interfaceOrientation: Orientation? {
        didSet {
            for recorder in self.activeRecorders {
                recorder.interfaceOrientation = self.interfaceOrientation
            }
        }
    }
    
#endif
    
    public var videoDevices: [VideoDevice] {
        return AVCaptureDevice.DiscoverySession(
            deviceTypes: VideoDevice.BuiltIn.allCases.compactMap({ $0.raw }),
            mediaType: .video,
            position: .unspecified
        ).devices.compactMap({
            VideoDevice($0)
        })
    }
    
    public var audioDevices: [AudioDevice] {
        return AVCaptureDevice.DiscoverySession(
            deviceTypes: [ .builtInMicrophone ],
            mediaType: .audio,
            position: .unspecified
        ).devices.compactMap({
            AudioDevice($0)
        })
    }
    
    public var activeVideoPreset: VideoDevice.Preset? {
        return self._activeState?.videoPreset
    }
    
    public var activeVideoDevice: VideoDevice? {
        return self._activeState?.videoDevice
    }
    
    public var activeAudioDevice: AudioDevice? {
        return self._activeState?.audioDevice
    }
    
    public var activeOutputs: [Output] {
        return self._activeState?.outputs ?? []
    }
    
    public var activeRecorders: [Recorder] {
        return self._activeState?.recorders ?? []
    }

    public let session = AVCaptureSession()
    
#if os(iOS)
    
    public let motionManager = CMMotionManager()
    
#endif
    
    @MonadicSignal
    public let onStarted = Signal< Void, Void >()
    
    @MonadicSignal
    public let onStopped = Signal< Void, Void >()
    
#if os(iOS)
    
    @MonadicSignal
    public let onDeviceOrientation = Signal< Void, Orientation? >()
    
    @MonadicSignal
    public let onInterfaceOrientation = Signal< Void, Orientation? >()
    
#endif
    
    @MonadicSignal
    public let onStartConfiguration = Signal< Void, Void >()
    
    @MonadicSignal
    public let onFinishConfiguration = Signal< Void, Void >()
    
    private var _activeState: State?
    private var _queue = DispatchQueue(label: "KindCamera.Session")
    private var _captureSessionStartObserver: NSObjectProtocol?
    private var _captureSessionStopObserver: NSObjectProtocol?
    
    public init() {
        self._setup()
    }
    
    deinit {
        self.stop()
    }
    
}

extension Session : Equatable {
    
    public static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs === rhs
    }
    
}

extension Session : @unchecked Sendable {
}

private extension Session {
    
    func _setup() {
#if os(iOS)
        self.motionManager.accelerometerUpdateInterval = 0.1
#endif
    }
    
    @MainActor
    func _subscribeSession() {
        self._captureSessionStartObserver = NotificationCenter.default.addObserver(
            forName: .AVCaptureSessionDidStartRunning,
            object: self.session,
            queue: .main,
            using: { [weak self] _ in self?._didStart() }
        )
        self._captureSessionStopObserver = NotificationCenter.default.addObserver(
            forName: .AVCaptureSessionDidStopRunning,
            object: self.session,
            queue: .main,
            using: { [weak self] _ in self?._didStop() }
        )
#if os(iOS)
        self._subscribeDeviceOrientaion()
#endif
    }
    
    @MainActor
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
            self.onDeviceOrientation.emit(deviceOrientation)
        }
    }
    
    func _set(interfaceOrientation: Orientation?) {
        if self.interfaceOrientation != interfaceOrientation {
            self.interfaceOrientation = interfaceOrientation
            self.onInterfaceOrientation.emit(interfaceOrientation)
        }
    }
    
    @MainActor
    func _currentUnterfaceOrientation() -> Orientation? {
        var windowScene: UIWindowScene? = nil
        for scene in UIApplication.shared.connectedScenes {
            guard let scene = scene as? UIWindowScene else { continue }
            windowScene = scene
        }
        guard let windowScene = windowScene else { return nil }
        if #available(iOS 16.0, *) {
            return .init(windowScene.effectiveGeometry.interfaceOrientation)
        }
        return .init(windowScene.interfaceOrientation)
    }
    
    @MainActor
    func _subscribeDeviceOrientaion() {
        self._set(deviceOrientation: .init(UIDevice.current.orientation))
        self._set(interfaceOrientation: self._currentUnterfaceOrientation())
        self.motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else {
                return
            }
            self?._handle(accelerometer: data)
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
        willConfigure: (@MainActor () -> Void)? = nil,
        configureVideoDevice: (@Sendable (VideoDevice.Configuration) -> Void)? = nil,
        configureAudioDevice: (@Sendable (AudioDevice.Configuration) -> Void)? = nil,
        didConfigure: (@MainActor () -> Void)? = nil,
        didStart: (@MainActor () -> Void)? = nil
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
                }
            }
            if let configure = configureVideoDevice {
                new.videoDevice.configuration(configure)
            }
            if old?.videoDevice !== new.videoDevice {
                if let videoDevice = old?.videoDevice {
                    self.session.removeInput(videoDevice.input)
                }
                if self.session.canAddInput(new.videoDevice.input) == true {
                    self.session.addInput(new.videoDevice.input)
                }
            }
            if let configure = configureAudioDevice, let audioDevice = new.audioDevice {
                audioDevice.configuration(configure)
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
            if let oldOutputs = old?.outputs {
                do {
                    let outputs = oldOutputs.filter({ output in
                        return new.outputs.contains(where: { $0 === output }) == false
                    })
                    for output in outputs {
                        self.session.removeOutput(output.output)
                        output.detach()
                    }
                }
                do {
                    let outputs = new.outputs.filter({ output in
                        return oldOutputs.contains(where: { $0 === output }) == false
                    })
                    for output in outputs {
                        if self.session.canAddOutput(output.output) == true {
                            self.session.addOutput(output.output)
                        }
                        output.attach(session: self)
                    }
                }
            } else {
                for output in new.outputs {
                    if self.session.canAddOutput(output.output) == true {
                        self.session.addOutput(output.output)
                    }
                    output.attach(session: self)
                }
            }
            if let oldRecorders = old?.recorders {
                do {
                    let recorders = oldRecorders.filter({ recorder in
                        return new.recorders.contains(where: { $0 === recorder }) == false
                    })
                    for recorder in recorders {
                        self.session.removeOutput(recorder.output)
                        recorder.detach()
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
                        recorder.attach(session: self)
                    }
                }
            } else {
                for recorder in new.recorders {
                    if self.session.canAddOutput(recorder.output) == true {
                        self.session.addOutput(recorder.output)
                    }
                    recorder.attach(session: self)
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
        self.onStarted.emit()
    }
    
    func _didStop() {
        self.isStarted = false
        self.onStopped.emit()
    }
    
#if os(iOS)
    
    @MainActor
    func _handle(accelerometer data: CMAccelerometerData) {
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

public extension Session {

    func start(
        video: Discovery.Video,
        audio: AudioDevice? = nil,
        outputs: [Output] = [],
        recorders: [Recorder] = []
    ) {
        self.start(
            videoPreset: video.preset,
            videoDevice: video.device,
            audioDevice: audio,
            outputs: outputs,
            recorders: recorders
        )
    }
    
    func start(
        videoPreset: VideoDevice.Preset,
        videoDevice: VideoDevice,
        audioDevice: AudioDevice? = nil,
        outputs: [Output] = [],
        recorders: [Recorder] = []
    ) {
        guard self.isStarting == false && self.isStarted == false else {
            return
        }
        self.isStarting = true
        self._start(.init(
            videoPreset: videoPreset,
            videoDevice: videoDevice,
            audioDevice: audioDevice,
            outputs: outputs,
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
    
    @inlinable
    func set(
        video: Discovery.Video,
        completion: @escaping @Sendable () -> Void
    ) {
        self.configure(
            videoPreset: video.preset,
            videoDevice: video.device,
            completion: completion
        )
    }
    
    @inlinable
    func set(
        preset: VideoDevice.Preset,
        device: VideoDevice,
        completion: @escaping @Sendable () -> Void
    ) {
        return self.configure(
            videoPreset: preset,
            videoDevice: device,
            completion: completion
        )
    }
    
    @inlinable
    func set(
        device: AudioDevice,
        completion: @escaping @Sendable () -> Void
    ) {
        return self.configure(
            audioDevice: device,
            completion: completion
        )
    }
    
    func configure(
        videoPreset: VideoDevice.Preset? = nil,
        videoDevice: VideoDevice? = nil,
        audioDevice: AudioDevice? = nil,
        outputs: [Output]? = nil,
        recorders: [Recorder]? = nil,
        configureVideoDevice: (@Sendable (VideoDevice.Configuration) -> Void)? = nil,
        configureAudioDevice: (@Sendable (AudioDevice.Configuration) -> Void)? = nil,
        completion: @escaping @Sendable () -> Void
    ) {
        guard let activeState = self._activeState else {
            return
        }
        self._configure(
            old: activeState,
            new: .init(
                videoPreset: videoPreset ?? activeState.videoPreset,
                videoDevice: videoDevice ?? activeState.videoDevice,
                audioDevice: audioDevice ?? activeState.audioDevice,
                outputs: outputs ?? activeState.outputs,
                recorders: recorders ?? activeState.recorders
            ),
            willConfigure: {
                self._unsubscribeSession()
                self.session.stopRunning()
                self.onStartConfiguration.emit()
            },
            configureVideoDevice: configureVideoDevice,
            configureAudioDevice: configureAudioDevice,
            didStart: {
                self._subscribeSession()
                self.onFinishConfiguration.emit()
                completion()
            }
        )
    }
    
}
