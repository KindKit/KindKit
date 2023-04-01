//
//  KindKit
//

#if os(iOS)

import UIKit
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

final class KKCameraPreviewView : UIView {
    
    weak var kkDelegate: KKCameraPreviewViewDelegate?
    var kkCameraSession: CameraSession? {
        didSet {
            guard self.kkCameraSession !== oldValue else { return }
            self.kkPreviewLayer.session = self.kkCameraSession?.session
            self.kkVideoDevice = self.kkCameraSession?.activeVideoDevice
            if let cameraSession = self.kkCameraSession, let connection = self.kkPreviewLayer.connection {
                if connection.isVideoOrientationSupported == true {
                    if let avOrientation = cameraSession.interfaceOrientation?.avOrientation {
                        connection.videoOrientation = avOrientation
                    } else {
                        connection.videoOrientation = .portrait
                    }
                }
                if connection.isVideoMirroringSupported == true {
                    connection.automaticallyAdjustsVideoMirroring = true
                }
            }
        }
    }
    var kkVideoDevice: CameraSession.Device.Video?
    var kkPreviewLayer: AVCaptureVideoPreviewLayer {
        return self.layer as! AVCaptureVideoPreviewLayer
    }
    lazy var kkFocusGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleFocusGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    lazy var kkZoomPanGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handleZoomGesture(pan:)))
        gesture.delegate = self
        return gesture
        
    }()
    lazy var kkZoomPinchGesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(self._handleZoomGesture(pinch:)))
        gesture.delegate = self
        return gesture
    }()
    var kkZoomPanTranslation: Double?
    var kkZoomPinchBegin: Double?
    
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(self.kkFocusGesture)
        self.addGestureRecognizer(self.kkZoomPanGesture)
        self.addGestureRecognizer(self.kkZoomPinchGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKCameraPreviewView {
    
    func update(view: UI.View.CameraPreview) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(cameraSession: view.cameraSession)
        self.update(mode: view.mode)
        self.update(zoom: view.zoom)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
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
    
    func update(zoom: Double) {
        guard let videoDevice = self.kkVideoDevice else {
            return
        }
        do {
            try videoDevice.configuration({
                $0.set(videoZoom: zoom)
            })
        } catch {
        }
    }
    
    func update(orientation: CameraSession.Orientation?) {
        if let connection = self.kkPreviewLayer.connection {
            if connection.isVideoOrientationSupported == true {
                if let avOrientation = orientation?.avOrientation {
                    connection.videoOrientation = avOrientation
                } else {
                    connection.videoOrientation = .portrait
                }
            }
        }
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkCameraSession = nil
        self.kkDelegate = nil
    }
    
}

private extension KKCameraPreviewView {
    
    @objc
    func _handleFocusGesture(_ gesture: UITapGestureRecognizer) {
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
    
    @objc
    func _handleZoomGesture(pan gesture: UIPanGestureRecognizer) {
        guard let videoDevice = self.kkVideoDevice else {
            return
        }
        let currentTranslation = Double(gesture.translation(in: self).y)
        switch gesture.state {
        case .began:
            self.kkZoomPanTranslation = currentTranslation
            self.kkDelegate?.beginZooming(self)
        case .changed:
            guard let previousTranslation = self.kkZoomPanTranslation else {
                return
            }
            let delta = currentTranslation - previousTranslation
            self.kkZoomPanTranslation = currentTranslation
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: videoDevice.videoZoom() + (delta / 75))
                })
                self.kkDelegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
        case .ended, .cancelled:
            guard let previousTranslation = self.kkZoomPanTranslation else {
                return
            }
            let delta = currentTranslation - previousTranslation
            self.kkZoomPanTranslation = currentTranslation
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: videoDevice.videoZoom() + (delta / 75))
                })
                self.kkDelegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
            self.kkDelegate?.endZoom(self)
        default:
            break
        }
    }
    
    @objc
    func _handleZoomGesture(pinch gesture: UIPinchGestureRecognizer) {
        guard let videoDevice = self.kkVideoDevice else {
            return
        }
        switch gesture.state {
        case .began:
            self.kkZoomPinchBegin = videoDevice.videoZoom()
            self.kkDelegate?.beginZooming(self)
        case .changed:
            guard let zoomPinchBegin = self.kkZoomPinchBegin else {
                return
            }
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: zoomPinchBegin * Double(gesture.scale))
                })
                self.kkDelegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
        case .ended, .cancelled:
            guard let zoomPinchBegin = self.kkZoomPinchBegin else {
                return
            }
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: zoomPinchBegin * Double(gesture.scale))
                })
                self.kkDelegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
            self.kkDelegate?.endZoom(self)
        default:
            break
        }
    }
    
}

extension KKCameraPreviewView : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let cameraSession = self.kkCameraSession else {
            return false
        }
        guard cameraSession.isStarted == true else {
            return false
        }
        guard let videoDevice = self.kkVideoDevice else {
            return false
        }
        if gestureRecognizer === self.kkFocusGesture {
            if videoDevice.isFocusOfPointSupported() == false && videoDevice.isExposureOfPointSupported() == false {
                return false
            }
            return self.kkDelegate?.shouldFocus(self) ?? false
        } else if gestureRecognizer === self.kkZoomPanGesture || gestureRecognizer === self.kkZoomPinchGesture {
            let minZoom = videoDevice.minVideoZoom()
            let maxZoom = videoDevice.maxVideoZoom()
            if maxZoom - minZoom > .leastNonzeroMagnitude {
                return self.kkDelegate?.shouldZoom(self) ?? false
            }
        }
        return false
    }
    
}

#endif
