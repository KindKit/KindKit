//
//  KindKit
//

#if os(macOS)

import AppKit
import AVFoundation

extension UI.View.CameraPreview {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.CameraPreview
        typealias Content = KKCameraPreviewView

        static var reuseIdentificator: String {
            return "UI.View.CameraPreview"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKCameraPreviewView : NSView {
    
    override var isFlipped: Bool {
        return true
    }
    
    private weak var _delegate: KKCameraPreviewViewDelegate?
    
    private var _cameraSession: CameraSession? {
        didSet {
            guard self._cameraSession !== oldValue else { return }
            self._previewLayer.session = self._cameraSession?.session
            self._videoDevice = self._cameraSession?.activeVideoDevice
        }
    }
    private var _videoDevice: CameraSession.Device.Video?
    private var _previewLayer: AVCaptureVideoPreviewLayer
    private lazy var _focusGesture: NSClickGestureRecognizer = {
        let gesture = NSClickGestureRecognizer()
        gesture.delegate = self
        gesture.target = self
        gesture.action = #selector(self._handleFocusGesture(_:))
        return gesture
    }()
    
    override init(frame: NSRect) {
        self._previewLayer = AVCaptureVideoPreviewLayer()
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        self.layer = self._previewLayer
        
        self.addGestureRecognizer(self._focusGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKCameraPreviewView {
    
    func update(view: UI.View.CameraPreview) {
        self.update(frame: view.frame)
        self.update(cameraSession: view.cameraSession)
        self.update(mode: view.mode)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self._delegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(cameraSession: CameraSession) {
        self._cameraSession = cameraSession
    }
    
    func update(videoDevice: CameraSession.Device.Video?) {
        self._videoDevice = videoDevice
    }

    func update(mode: UI.View.CameraPreview.Mode) {
        switch mode {
        case .origin: self._previewLayer.videoGravity = .resize
        case .aspectFit: self._previewLayer.videoGravity = .resizeAspect
        case .aspectFill: self._previewLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func update(color: UI.Color?) {
        self._previewLayer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
        self._cameraSession = nil
        self._delegate = nil
    }
    
}

private extension KKCameraPreviewView {
    
    @objc
    func _handleFocusGesture(_ gesture: NSClickGestureRecognizer) {
        guard let videoDevice = self._videoDevice else {
            return
        }
        let viewPoint = gesture.location(in: self)
        let devicePoint = self._previewLayer.captureDevicePointConverted(fromLayerPoint: viewPoint)
        let focusPoint = Point(devicePoint)
        do {
            try videoDevice.configuration({
                if $0.isFocusOfPointSupported() == true {
                    $0.set(focusOfPoint: .on(focusPoint))
                    if $0.isFocusSupported(.auto) == true {
                        $0.set(focus: .auto)
                    }
                }
                if $0.isExposureOfPointSupported() == true {
                    $0.set(exposureOfPoint: .on(focusPoint))
                    if $0.isExposureSupported(.continuous) == true {
                        $0.set(exposure: .continuous)
                    }
                }
            })
            self._delegate?.focus(self, point: .init(viewPoint))
        } catch {
        }
    }
    
}

extension KKCameraPreviewView : NSGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
        guard let videoDevice = self._videoDevice else {
            return false
        }
        if gestureRecognizer === self._focusGesture {
            if videoDevice.isFocusOfPointSupported() == false && videoDevice.isExposureOfPointSupported() == false {
                return false
            }
            return self._delegate?.shouldFocus(self) ?? false
        }
        return false
    }
    
}

#endif
