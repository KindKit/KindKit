//
//  KindKitGraphics
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath
import KindKitView

extension GraphicsView {
    
    struct Reusable : IReusable {
        
        typealias Owner = GraphicsView
        typealias Content = NativeGraphicsView

        static var reuseIdentificator: String {
            return "GraphicsView"
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

final class NativeGraphicsView : UIView {
    
    private var _canvas: IGraphicsCanvas
    
    private var _tapGestures: [GraphicsCanvasGesture : UITapGestureRecognizer]
    private var _longPressGestures: [GraphicsCanvasGesture : UILongPressGestureRecognizer]
    private var _panGestures: [GraphicsCanvasGesture : UIPanGestureRecognizer]
    private var _previousPanLocation: [GraphicsCanvasGesture : CGPoint]
    private var _pinchGesture: UIPinchGestureRecognizer!
    private var _rotationGesture: UIRotationGestureRecognizer!
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
        
        for canvasGesture in GraphicsCanvasGesture.allCases {
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
        
        self._pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self._handlePinchGesture(_:)))
        self.addGestureRecognizer(self._pinchGesture)
        self._simultaneouslyGestures.append(self._pinchGesture)
        
        self._rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self._handleRotationGesture(_:)))
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
        self._canvas.draw(GraphicsContext(cgContext), bounds: Rect(self.bounds))
    }

}

extension NativeGraphicsView {
    
    func update(view: GraphicsView) {
        self.update(canvas: view.canvas)
        self.update(locked: view.isLocked)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(canvas: IGraphicsCanvas) {
        self._canvas = canvas
        self.setNeedsDisplay()
    }
    
    func cleanup() {
    }
    
}

private extension NativeGraphicsView {
    
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
    func _handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        let scale = Float(gesture.scale)
        switch gesture.state {
        case .possible: break
        case .began: self._canvas.beginPinchGesture(scale: scale)
        case .changed: self._canvas.changePinchGesture(scale: scale)
        case .ended, .cancelled, .failed: self._canvas.endPinchGesture(scale: scale)
        @unknown default: break
        }
    }
    
    @objc
    func _handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        let angle = AngleFloat(radians: Float(gesture.rotation))
        switch gesture.state {
        case .possible: break
        case .began: self._canvas.beginRotationGesture(angle: angle)
        case .changed: self._canvas.changeRotationGesture(angle: angle)
        case .ended, .cancelled, .failed: self._canvas.endRotationGesture(angle: angle)
        @unknown default: break
        }
    }
    
}

extension NativeGraphicsView : UIGestureRecognizerDelegate {
    
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
