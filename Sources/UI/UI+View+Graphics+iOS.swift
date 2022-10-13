//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Graphics {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Graphics
        typealias Content = KKGraphicsView

        static var reuseIdentificator: String {
            return "UI.View.Graphics"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(canvas: owner.canvas)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKGraphicsView : UIView {
    
    private var _canvas: IGraphicsCanvas
    
    private var _tapGestures: [Graphics.Gesture : UITapGestureRecognizer]
    private var _longPressGestures: [Graphics.Gesture : UILongPressGestureRecognizer]
    private var _panGestures: [Graphics.Gesture : UIPanGestureRecognizer]
    private var _previousPanLocation: [Graphics.Gesture : CGPoint]
    private var _pinchGesture: UIPinchGestureRecognizer!
    private var _previousPinchLocation: CGPoint?
    private var _previousPinchScale: CGFloat?
    private var _rotationGesture: UIRotationGestureRecognizer!
    private var _previousRotationLocation: CGPoint?
    private var _previousRotationAngle: CGFloat?
    private var _simultaneouslyGestures: [UIGestureRecognizer]
    
    init(canvas: IGraphicsCanvas) {
        self._canvas = canvas
        self._tapGestures = [:]
        self._longPressGestures = [:]
        self._panGestures = [:]
        self._previousPanLocation = [:]
        self._simultaneouslyGestures = []
        
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        
        for canvasGesture in Graphics.Gesture.allCases {
            let numberOfTouches = canvasGesture.numberOfTouches
            do {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleTapGesture(_:)))
                gesture.numberOfTouchesRequired = numberOfTouches
                self._tapGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
            }
            do {
                let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self._handleLongPressGesture(_:)))
                gesture.numberOfTouchesRequired = numberOfTouches
                self._longPressGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
            }
            do {
                let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handlePanGesture(_:)))
                gesture.minimumNumberOfTouches = numberOfTouches
                gesture.maximumNumberOfTouches = numberOfTouches
                self._panGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
                self._simultaneouslyGestures.append(gesture)
            }
        }
        
        self._pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self._handlePinchGesture))
        self.addGestureRecognizer(self._pinchGesture)
        self._simultaneouslyGestures.append(self._pinchGesture)
        
        self._rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self._handleRotationGesture))
        self.addGestureRecognizer(self._rotationGesture)
        self._simultaneouslyGestures.append(self._rotationGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self._canvas.resize(SizeFloat(self.bounds.size))
    }
    
    override func draw(_ rect: CGRect) {
        guard let cgContext = UIGraphicsGetCurrentContext() else { return }
        self._canvas.draw(Graphics.Context(cgContext), bounds: Rect(self.bounds))
    }

}

extension KKGraphicsView {
    
    func update(view: UI.View.Graphics) {
        self.update(canvas: view.canvas)
        self.update(locked: view.isLocked)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    func update(locked: Bool) {
        self.isUserInteractionEnabled = locked == false
    }
    
    func update(canvas: IGraphicsCanvas) {
        self._canvas = canvas
        self.setNeedsDisplay()
    }
    
    func cleanup() {
    }
    
}

private extension KKGraphicsView {
    
    @objc
    func _handleTapGesture(_ gesture: UIGestureRecognizer) {
        guard let found = self._tapGestures.first(where: { $0.value === gesture }) else {
            return
        }
        let location = found.value.location(in: self)
        self._canvas.tapGesture(found.key, location: PointFloat(location))
    }
    
    @objc
    func _handleLongPressGesture(_ gesture: UIGestureRecognizer) {
        guard let found = self._tapGestures.first(where: { $0.value === gesture }) else {
            return
        }
        let location = found.value.location(in: self)
        self._canvas.longTapGesture(found.key, location: PointFloat(location))
    }
    
    @objc
    func _handlePanGesture(_ gesture: UIGestureRecognizer) {
        guard let found = self._panGestures.first(where: { $0.value === gesture }) else {
            return
        }
        switch found.value.state {
        case .possible: break
        case .began:
            let location = found.value.location(in: self)
            self._previousPanLocation[found.key] = location
            self._canvas.beginPanGesture(found.key, location: PointFloat(location))
        case .changed:
            if found.value.numberOfTouches != found.value.minimumNumberOfTouches {
                found.value.isEnabled = false
            } else {
                let location = found.value.location(in: self)
                self._previousPanLocation[found.key] = location
                self._canvas.changePanGesture(found.key, location: PointFloat(location))
            }
        case .ended, .cancelled, .failed:
            if let location = self._previousPanLocation[found.key] {
                self._previousPanLocation[found.key] = nil
                self._canvas.endPanGesture(found.key, location: PointFloat(location))
            }
            found.value.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handlePinchGesture() {
        switch self._pinchGesture.state {
        case .possible: break
        case .began:
            let location = self._pinchGesture.location(in: self)
            let scale = self._pinchGesture.scale
            self._previousPinchLocation = location
            self._previousPinchScale = scale
            self._canvas.beginPinchGesture(location: PointFloat(location), scale: Float(scale))
        case .changed:
            if self._pinchGesture.numberOfTouches != 2 {
                self._pinchGesture.isEnabled = false
            } else {
                let location = self._pinchGesture.location(in: self)
                let scale = self._pinchGesture.scale
                self._previousPinchLocation = location
                self._previousPinchScale = scale
                self._canvas.changePinchGesture(location: PointFloat(location), scale: Float(scale))
            }
        case .ended, .cancelled, .failed:
            if let location = self._previousPinchLocation, let scale = self._previousPinchScale {
                self._previousPinchLocation = nil
                self._previousPinchScale = nil
                self._canvas.endPinchGesture(location: PointFloat(location), scale: Float(scale))
            }
            self._pinchGesture.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handleRotationGesture() {
        switch self._rotationGesture.state {
        case .possible: break
        case .began:
            let location = self._rotationGesture.location(in: self)
            let angle = self._rotationGesture.rotation
            self._previousRotationLocation = location
            self._previousRotationAngle = angle
            self._canvas.beginRotationGesture(location: PointFloat(location), angle: AngleFloat(radians: Float(angle)))
        case .changed:
            if self._rotationGesture.numberOfTouches != 2 {
                self._rotationGesture.isEnabled = false
            } else {
                let location = self._rotationGesture.location(in: self)
                let angle = self._rotationGesture.rotation
                self._previousRotationLocation = location
                self._previousRotationAngle = angle
                self._canvas.changeRotationGesture(location: PointFloat(location), angle: AngleFloat(radians: Float(angle)))
            }
        case .ended, .cancelled, .failed:
            if let location = self._previousRotationLocation, let angle = self._previousRotationAngle {
                self._previousRotationLocation = nil
                self._previousRotationAngle = nil
                self._canvas.endRotationGesture(location: PointFloat(location), angle: AngleFloat(radians: Float(angle)))
            }
            self._rotationGesture.isEnabled = true
        @unknown default: break
        }
    }
    
}

extension KKGraphicsView : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let found = self._tapGestures.first(where: { $0.value === gestureRecognizer }) {
            return self._canvas.shouldTapGesture(found.key)
        } else if let found = self._longPressGestures.first(where: { $0.value === gestureRecognizer }) {
            return self._canvas.shouldLongTapGesture(found.key)
        } else if let found = self._panGestures.first(where: { $0.value === gestureRecognizer }) {
            return self._canvas.shouldPanGesture(found.key)
        } else if gestureRecognizer === self._pinchGesture {
            return self._canvas.shouldPinchGesture()
        } else if gestureRecognizer === self._rotationGesture {
            return self._canvas.shouldRotationGesture()
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard self._simultaneouslyGestures.contains(gestureRecognizer) == true else { return false }
        guard self._simultaneouslyGestures.contains(otherGestureRecognizer) == true else { return false }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self._tapGestures.first(where: { $0.value === gestureRecognizer }) != nil {
            if self._longPressGestures.first(where: { $0.value === otherGestureRecognizer }) != nil {
                return true
            }
        }
        return false
    }
    
}

#endif
