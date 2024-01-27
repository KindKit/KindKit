//
//  KindKit
//

#if os(macOS)

import AppKit
import AVFoundation
import KindCamera
import KindUI

extension View {
    
    struct Reusable : IReusable {
        
        typealias Owner = View
        typealias Content = KKCameraView

        static var reuseIdentificator: String {
            return "View"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKCameraView : NSView {
    
    weak var kkDelegate: KKCameraViewDelegate?
    var kkCameraSession: KindCamera.Session? {
        didSet {
            guard self.kkCameraSession !== oldValue else { return }
            self.kkPreviewLayer.session = self.kkCameraSession?.session
        }
    }
    var kkVideoDevice: KindCamera.Device.Video? {
        return self.kkCameraSession?.activeVideoDevice
    }
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

extension KKCameraView {
    
    func kk_update(view: View) {
        self.kk_update(frame: view.frame)
        self.kk_update(cameraSession: view.cameraSession)
        self.kk_update(mode: view.mode)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func kk_update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func kk_update(cameraSession: KindCamera.Session) {
        self.kkCameraSession = cameraSession
    }

    func kk_update(mode: View.Mode) {
        switch mode {
        case .origin: self.kkPreviewLayer.videoGravity = .resize
        case .aspectFit: self.kkPreviewLayer.videoGravity = .resizeAspect
        case .aspectFill: self.kkPreviewLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func kk_update(color: Color) {
        self.kkPreviewLayer.backgroundColor = color.native.cgColor
    }
    
    func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func kk_startConfiguration(_ snapshoot: Image?) {
    }

    func kk_finishConfiguration() {
    }
    
    func kk_cleanup() {
        self.kkCameraSession = nil
        self.kkDelegate = nil
    }
    
}

private extension KKCameraView {
    
    @objc
    func _handleFocusGesture(_ gesture: NSClickGestureRecognizer) {
        guard let videoDevice = self.kkVideoDevice else {
            return
        }
        let viewPoint = gesture.location(in: self)
        let devicePoint = self.kkPreviewLayer.captureDevicePointConverted(fromLayerPoint: viewPoint)
        let focusPoint = Point(devicePoint)
        videoDevice.configuration({
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
    }
    
}

extension KKCameraView : NSGestureRecognizerDelegate {
    
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
