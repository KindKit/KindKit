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
    
    private weak var _delegate: KKCameraPreviewViewDelegate?
    private var _cameraSession: CameraSession? {
        didSet {
            guard self._cameraSession !== oldValue else { return }
            self._previewLayer.session = self._cameraSession?.session
            self._videoDevice = self._cameraSession?.activeVideoDevice
            if let cameraSession = self._cameraSession, let connection = self._previewLayer.connection {
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
    private var _videoDevice: CameraSession.Device.Video?
    private var _previewLayer: AVCaptureVideoPreviewLayer {
        return self.layer as! AVCaptureVideoPreviewLayer
    }
    private lazy var _focusGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleFocusGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    private lazy var _zoomPanGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handleZoomGesture(pan:)))
        gesture.delegate = self
        return gesture
        
    }()
    private lazy var _zoomPinchGesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(self._handleZoomGesture(pinch:)))
        gesture.delegate = self
        return gesture
    }()
    private var _zoomPanTranslation: Double?
    private var _zoomPinchBegin: Double?
    
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(self._focusGesture)
        self.addGestureRecognizer(self._zoomPanGesture)
        self.addGestureRecognizer(self._zoomPinchGesture)
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
        self._delegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
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
    
    func update(zoom: Double) {
        guard let videoDevice = self._videoDevice else {
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
        if let connection = self._previewLayer.connection {
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
        self._cameraSession = nil
        self._delegate = nil
    }
    
}

private extension KKCameraPreviewView {
    
    @objc
    func _handleFocusGesture(_ gesture: UITapGestureRecognizer) {
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
    
    @objc
    func _handleZoomGesture(pan gesture: UIPanGestureRecognizer) {
        guard let videoDevice = self._videoDevice else {
            return
        }
        let currentTranslation = Double(gesture.translation(in: self).y)
        switch gesture.state {
        case .began:
            self._zoomPanTranslation = currentTranslation
            self._delegate?.beginZooming(self)
        case .changed:
            guard let previousTranslation = self._zoomPanTranslation else {
                return
            }
            let delta = currentTranslation - previousTranslation
            self._zoomPanTranslation = currentTranslation
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: videoDevice.videoZoom() + (delta / 75))
                })
                self._delegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
        case .ended, .cancelled:
            guard let previousTranslation = self._zoomPanTranslation else {
                return
            }
            let delta = currentTranslation - previousTranslation
            self._zoomPanTranslation = currentTranslation
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: videoDevice.videoZoom() + (delta / 75))
                })
                self._delegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
            self._delegate?.endZoom(self)
        default:
            break
        }
    }
    
    @objc
    func _handleZoomGesture(pinch gesture: UIPinchGestureRecognizer) {
        guard let videoDevice = self._videoDevice else {
            return
        }
        switch gesture.state {
        case .began:
            self._zoomPinchBegin = videoDevice.videoZoom()
            self._delegate?.beginZooming(self)
        case .changed:
            guard let zoomPinchBegin = self._zoomPinchBegin else {
                return
            }
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: zoomPinchBegin * Double(gesture.scale))
                })
                self._delegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
        case .ended, .cancelled:
            guard let zoomPinchBegin = self._zoomPinchBegin else {
                return
            }
            do {
                try videoDevice.configuration({
                    $0.set(videoZoom: zoomPinchBegin * Double(gesture.scale))
                })
                self._delegate?.zooming(self, videoDevice.videoZoom())
            } catch {
            }
            self._delegate?.endZoom(self)
        default:
            break
        }
    }
    
}

extension KKCameraPreviewView : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let cameraSession = self._cameraSession else {
            return false
        }
        guard cameraSession.isStarted == true else {
            return false
        }
        guard let videoDevice = self._videoDevice else {
            return false
        }
        if gestureRecognizer === self._focusGesture {
            if videoDevice.isFocusOfPointSupported() == false && videoDevice.isExposureOfPointSupported() == false {
                return false
            }
            return self._delegate?.shouldFocus(self) ?? false
        } else if gestureRecognizer === self._zoomPanGesture || gestureRecognizer === self._zoomPinchGesture {
            let minZoom = videoDevice.minVideoZoom()
            let maxZoom = videoDevice.maxVideoZoom()
            if maxZoom - minZoom > .leastNonzeroMagnitude {
                return self._delegate?.shouldZoom(self) ?? false
            }
        }
        return false
    }
    
}

#endif
