//
//  KindKit
//

#if os(iOS)

import UIKit
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

final class KKCameraView : UIView {
    
    weak var kkDelegate: KKCameraViewDelegate?
    var kkCameraSession: KindCamera.Session? {
        didSet {
            guard self.kkCameraSession !== oldValue else { return }
            self.kkPreviewLayer.session = self.kkCameraSession?.session
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
    var kkVideoDevice: KindCamera.Device.Video? {
        return self.kkCameraSession?.activeVideoDevice
    }
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
    var kkBlurView: UIVisualEffectView? {
        willSet {
            guard self.kkBlurView != newValue else { return }
            if let view = self.kkBlurView {
                view.removeFromSuperview()
            }
        }
        didSet {
            guard self.kkBlurView != oldValue else { return }
            if let view = self.kkBlurView {
                view.frame = self.bounds
                self.addSubview(view)
            }
        }
    }
    var kkSnapshootView: UIImageView? {
        willSet {
            guard self.kkSnapshootView != newValue else { return }
            if let view = self.kkSnapshootView {
                view.removeFromSuperview()
            }
        }
        didSet {
            guard self.kkSnapshootView != oldValue else { return }
            if let view = self.kkSnapshootView {
                view.frame = self.bounds
                self.addSubview(view)
            }
        }
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.kkSnapshootView?.frame = self.bounds
        self.kkBlurView?.frame = self.bounds
    }
    
}

extension KKCameraView {
    
    func kk_update(view: View) {
        self.kk_update(frame: view.frame)
        self.kk_update(transform: view.transform)
        self.kk_update(cameraSession: view.cameraSession)
        self.kk_update(mode: view.mode)
        self.kk_update(zoom: view.zoom)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func kk_update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func kk_update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
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
    
    func kk_update(zoom: Double) {
        guard let videoDevice = self.kkVideoDevice else {
            return
        }
        videoDevice.configuration({
            $0.set(videoZoom: zoom)
        })
    }
    
    func kk_update(orientation: KindCamera.Orientation?) {
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
    
    func kk_update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func kk_startConfiguration(_ snapshoot: Image?) {
        guard self.kkBlurView == nil else { return }
        if let snapshoot = snapshoot {
            self.kkSnapshootView = UIImageView(image: snapshoot.native)
        }
        self.kkBlurView = UIVisualEffectView(effect: nil)
        UIView.transition(with: self, duration: 0.25, options: [ .beginFromCurrentState, .transitionCrossDissolve ], animations: {
            self.kkBlurView?.effect = UIBlurEffect(style: .regular)
        })
    }

    func kk_finishConfiguration() {
        guard self.kkBlurView != nil else { return }
        self.kkSnapshootView = nil
        UIView.transition(with: self, duration: 0.25, options: [ .beginFromCurrentState, .transitionCrossDissolve ], animations: {
            self.kkBlurView?.effect = nil
        }, completion: { _ in
            self.kkBlurView = nil
        })
    }

    func kk_cleanup() {
        self.kkCameraSession = nil
        self.kkDelegate = nil
    }
    
}

private extension KKCameraView {
    
    @objc
    func _handleFocusGesture(_ gesture: UITapGestureRecognizer) {
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
            videoDevice.configuration({
                $0.set(videoZoom: videoDevice.videoZoom() + (delta / 75))
            })
            self.kkDelegate?.zooming(self, videoDevice.videoZoom())
        case .ended, .cancelled:
            guard let previousTranslation = self.kkZoomPanTranslation else {
                return
            }
            let delta = currentTranslation - previousTranslation
            self.kkZoomPanTranslation = currentTranslation
            videoDevice.configuration({
                $0.set(videoZoom: videoDevice.videoZoom() + (delta / 75))
            })
            self.kkDelegate?.zooming(self, videoDevice.videoZoom())
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
            videoDevice.configuration({
                $0.set(videoZoom: zoomPinchBegin * Double(gesture.scale))
            })
            self.kkDelegate?.zooming(self, videoDevice.videoZoom())
        case .ended, .cancelled:
            guard let zoomPinchBegin = self.kkZoomPinchBegin else {
                return
            }
            videoDevice.configuration({
                $0.set(videoZoom: zoomPinchBegin * Double(gesture.scale))
            })
            self.kkDelegate?.zooming(self, videoDevice.videoZoom())
            self.kkDelegate?.endZoom(self)
        default:
            break
        }
    }
    
}

extension KKCameraView : UIGestureRecognizerDelegate {
    
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
