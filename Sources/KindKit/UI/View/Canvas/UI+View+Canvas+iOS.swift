//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Canvas {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Canvas
        typealias Content = KKCanvasView

        static var reuseIdentificator: String {
            return "UI.View.Canvas"
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

final class KKCanvasView : UIView {
    
    private var _canvas: IGraphicsCanvas?
    
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
    
    override init(frame: CGRect) {
        self._tapGestures = [:]
        self._longPressGestures = [:]
        self._panGestures = [:]
        self._previousPanLocation = [:]
        self._simultaneouslyGestures = []
        
        super.init(frame: frame)
        
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
        if let canvas = self._canvas {
            canvas.resize(Size(self.bounds.size))
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let cgContext = UIGraphicsGetCurrentContext() else { return }
        if let canvas = self._canvas {
            canvas.draw(Graphics.Context(cgContext), bounds: Rect(self.bounds))
        }
    }

}

extension KKCanvasView {
    
    func update(view: UI.View.Canvas) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(canvas: view.canvas)
        self.update(locked: view.isLocked)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(locked: Bool) {
        self.isUserInteractionEnabled = locked == false
    }
    
    func update(canvas: IGraphicsCanvas?) {
        self._canvas = canvas
        self.setNeedsDisplay()
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

private extension KKCanvasView {
    
    @objc
    func _handleTapGesture(_ gesture: UIGestureRecognizer) {
        guard let canvas = self._canvas else {
            return
        }
        guard let found = self._tapGestures.first(where: { $0.value === gesture }) else {
            return
        }
        let location = found.value.location(in: self)
        canvas.tapGesture(found.key, location: Point(location))
    }
    
    @objc
    func _handleLongPressGesture(_ gesture: UIGestureRecognizer) {
        guard let canvas = self._canvas else {
            return
        }
        guard let found = self._tapGestures.first(where: { $0.value === gesture }) else {
            return
        }
        let location = found.value.location(in: self)
        canvas.longTapGesture(found.key, location: Point(location))
    }
    
    @objc
    func _handlePanGesture(_ gesture: UIGestureRecognizer) {
        guard let canvas = self._canvas else {
            return
        }
        guard let found = self._panGestures.first(where: { $0.value === gesture }) else {
            return
        }
        switch found.value.state {
        case .possible: break
        case .began:
            let location = found.value.location(in: self)
            self._previousPanLocation[found.key] = location
            canvas.beginPanGesture(found.key, location: Point(location))
        case .changed:
            if found.value.numberOfTouches != found.value.minimumNumberOfTouches {
                found.value.isEnabled = false
            } else {
                let location = found.value.location(in: self)
                self._previousPanLocation[found.key] = location
                canvas.changePanGesture(found.key, location: Point(location))
            }
        case .ended, .cancelled, .failed:
            if let location = self._previousPanLocation[found.key] {
                self._previousPanLocation[found.key] = nil
                canvas.endPanGesture(found.key, location: Point(location))
            }
            found.value.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handlePinchGesture() {
        guard let canvas = self._canvas else {
            return
        }
        switch self._pinchGesture.state {
        case .possible: break
        case .began:
            let location = self._pinchGesture.location(in: self)
            let scale = self._pinchGesture.scale
            self._previousPinchLocation = location
            self._previousPinchScale = scale
            canvas.beginPinchGesture(location: Point(location), scale: Double(scale))
        case .changed:
            if self._pinchGesture.numberOfTouches != 2 {
                self._pinchGesture.isEnabled = false
            } else {
                let location = self._pinchGesture.location(in: self)
                let scale = self._pinchGesture.scale
                self._previousPinchLocation = location
                self._previousPinchScale = scale
                canvas.changePinchGesture(location: Point(location), scale: Double(scale))
            }
        case .ended, .cancelled, .failed:
            if let location = self._previousPinchLocation, let scale = self._previousPinchScale {
                self._previousPinchLocation = nil
                self._previousPinchScale = nil
                canvas.endPinchGesture(location: Point(location), scale: Double(scale))
            }
            self._pinchGesture.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handleRotationGesture() {
        guard let canvas = self._canvas else {
            return
        }
        switch self._rotationGesture.state {
        case .possible: break
        case .began:
            let location = self._rotationGesture.location(in: self)
            let angle = self._rotationGesture.rotation
            self._previousRotationLocation = location
            self._previousRotationAngle = angle
            canvas.beginRotationGesture(location: Point(location), angle: Angle(radians: Double(angle)))
        case .changed:
            if self._rotationGesture.numberOfTouches != 2 {
                self._rotationGesture.isEnabled = false
            } else {
                let location = self._rotationGesture.location(in: self)
                let angle = self._rotationGesture.rotation
                self._previousRotationLocation = location
                self._previousRotationAngle = angle
                canvas.changeRotationGesture(location: Point(location), angle: Angle(radians: Double(angle)))
            }
        case .ended, .cancelled, .failed:
            if let location = self._previousRotationLocation, let angle = self._previousRotationAngle {
                self._previousRotationLocation = nil
                self._previousRotationAngle = nil
                canvas.endRotationGesture(location: Point(location), angle: Angle(radians: Double(angle)))
            }
            self._rotationGesture.isEnabled = true
        @unknown default: break
        }
    }
    
}

extension KKCanvasView : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let canvas = self._canvas else {
            return false
        }
        if let found = self._tapGestures.first(where: { $0.value === gestureRecognizer }) {
            return canvas.shouldTapGesture(found.key)
        } else if let found = self._longPressGestures.first(where: { $0.value === gestureRecognizer }) {
            return canvas.shouldLongTapGesture(found.key)
        } else if let found = self._panGestures.first(where: { $0.value === gestureRecognizer }) {
            return canvas.shouldPanGesture(found.key)
        } else if gestureRecognizer === self._pinchGesture {
            return canvas.shouldPinchGesture()
        } else if gestureRecognizer === self._rotationGesture {
            return canvas.shouldRotationGesture()
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
