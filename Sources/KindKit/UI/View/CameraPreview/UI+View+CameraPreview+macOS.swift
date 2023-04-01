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
    
    weak var kkDelegate: KKCameraPreviewViewDelegate?
    var kkCameraSession: CameraSession? {
        didSet {
            guard self.kkCameraSession !== oldValue else { return }
            self.kkPreviewLayer.session = self.kkCameraSession?.session
            self.kkVideoDevice = self.kkCameraSession?.activeVideoDevice
        }
    }
    var kkVideoDevice: CameraSession.Device.Video?
    var kkPreviewLayer: AVCaptureVideoPreviewLayer
    lazy var kkFocusGesture: NSClickGestureRecognizer = {
        let gesture = NSClickGestureRecognizer()
        gesture.delegate = self
        gesture.target = self
        gesture.action = #selector(self._handleFocusGesture(_:))
        return gesture
    }()
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        self.kkPreviewLayer = AVCaptureVideoPreviewLayer()
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        self.layer = self.kkPreviewLayer
        
        self.addGestureRecognizer(self.kkFocusGesture)
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
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(cameraSession: CameraSession) {
        self.kkCameraSession = cameraSession
    }
    
    func update(videoDevice: CameraSession.Device.Video?) {
        self.kkVideoDevice = videoDevice
    }

    func update(mode: UI.View.CameraPreview.Mode) {
        switch mode {
        case .origin: self.kkPreviewLayer.videoGravity = .resize
        case .aspectFit: self.kkPreviewLayer.videoGravity = .resizeAspect
        case .aspectFill: self.kkPreviewLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func update(color: UI.Color?) {
        self.kkPreviewLayer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkCameraSession = nil
        self.kkDelegate = nil
    }
    
}

private extension KKCameraPreviewView {
    
    @objc
    func _handleFocusGesture(_ gesture: NSClickGestureRecognizer) {
        guard let videoDevice = self.kkVideoDevice else {
            return
        }
        let viewPoint = gesture.location(in: self)
        let devicePoint = self.kkPreviewLayer.captureDevicePointConverted(fromLayerPoint: viewPoint)
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
            self.kkDelegate?.focus(self, point: .init(viewPoint))
        } catch {
        }
    }
    
}

extension KKCameraPreviewView : NSGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
        guard let videoDevice = self.kkVideoDevice else {
            return false
        }
        if gestureRecognizer === self.kkFocusGesture {
            if videoDevice.isFocusOfPointSupported() == false && videoDevice.isExposureOfPointSupported() == false {
                return false
            }
            return self.kkDelegate?.shouldFocus(self) ?? false
        }
        return false
    }
    
}

#endif
