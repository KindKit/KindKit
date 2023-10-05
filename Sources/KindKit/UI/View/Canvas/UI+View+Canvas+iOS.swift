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
    
    var kkDelegate: KKUIViewCanvasDelegate?
    var kkTapGestures: [UI.View.Canvas.Gesture : UITapGestureRecognizer] = [:]
    var kkLongPressGestures: [UI.View.Canvas.Gesture : UILongPressGestureRecognizer] = [:]
    var kkPanGestures: [UI.View.Canvas.Gesture : UIPanGestureRecognizer] = [:]
    var kkPreviousPanLocation: [UI.View.Canvas.Gesture : CGPoint] = [:]
    var kkPinchGesture: UIPinchGestureRecognizer!
    var kkPreviousPinchLocation: CGPoint?
    var kkPreviousPinchScale: CGFloat?
    var kkRotationGesture: UIRotationGestureRecognizer!
    var kkPreviousRotationLocation: CGPoint?
    var kkPreviousRotationAngle: CGFloat?
    var kkSimultaneouslyGestures: [UIGestureRecognizer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        for canvasGesture in UI.View.Canvas.Gesture.allCases {
            let numberOfTouches = canvasGesture.numberOfTouches
            do {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleTapGesture(_:)))
                gesture.numberOfTouchesRequired = numberOfTouches
                self.kkTapGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
            }
            do {
                let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self._handleLongPressGesture(_:)))
                gesture.numberOfTouchesRequired = numberOfTouches
                self.kkLongPressGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
            }
            do {
                let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handlePanGesture(_:)))
                gesture.minimumNumberOfTouches = numberOfTouches
                gesture.maximumNumberOfTouches = numberOfTouches
                self.kkPanGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
                self.kkSimultaneouslyGestures.append(gesture)
            }
        }
        
        self.kkPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self._handlePinchGesture))
        self.addGestureRecognizer(self.kkPinchGesture)
        self.kkSimultaneouslyGestures.append(self.kkPinchGesture)
        
        self.kkRotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self._handleRotationGesture))
        self.addGestureRecognizer(self.kkRotationGesture)
        self.kkSimultaneouslyGestures.append(self.kkRotationGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let delegate = self.kkDelegate else { return }
        delegate.resize(Size(self.bounds.size))
    }
    
    override func draw(_ rect: CGRect) {
        guard let delegate = self.kkDelegate else { return }
        guard let cgContext = UIGraphicsGetCurrentContext() else { return }
        delegate.draw(Graphics.Context(cgContext, size: self.bounds.size))
    }

}

extension KKCanvasView {
    
    func update(view: UI.View.Canvas) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(locked: view.isLocked)
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
    
    func update(locked: Bool) {
        self.isUserInteractionEnabled = locked == false
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKCanvasView {
    
    @objc
    func _handleTapGesture(_ gesture: UIGestureRecognizer) {
        guard let delegate = self.kkDelegate else { return }
        guard let found = self.kkTapGestures.first(where: { $0.value === gesture }) else { return }
        delegate.handle(tap: .init(
            gesture: found.key,
            location: Point(found.value.location(in: self))
        ))
    }
    
    @objc
    func _handleLongPressGesture(_ gesture: UIGestureRecognizer) {
        guard let delegate = self.kkDelegate else { return }
        guard let found = self.kkLongPressGestures.first(where: { $0.value === gesture }) else { return }
        delegate.handle(longTap: .init(
            gesture: found.key,
            location: Point(found.value.location(in: self))
        ))
    }
    
    @objc
    func _handlePanGesture(_ gesture: UIGestureRecognizer) {
        guard let delegate = self.kkDelegate else { return }
        guard let found = self.kkPanGestures.first(where: { $0.value === gesture }) else { return }
        switch found.value.state {
        case .possible: 
            break
        case .began:
            let location = found.value.location(in: self)
            self.kkPreviousPanLocation[found.key] = location
            delegate.handle(pan: .init(
                gesture: found.key,
                state: .begin,
                location: Point(location)
            ))
        case .changed:
            if found.value.numberOfTouches != found.value.minimumNumberOfTouches {
                found.value.isEnabled = false
            } else {
                let location = found.value.location(in: self)
                self.kkPreviousPanLocation[found.key] = location
                delegate.handle(pan: .init(
                    gesture: found.key,
                    state: .change,
                    location: Point(location)
                ))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousPanLocation[found.key] {
                self.kkPreviousPanLocation[found.key] = nil
                delegate.handle(pan: .init(
                    gesture: found.key,
                    state: .end,
                    location: Point(location)
                ))
            }
            found.value.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handlePinchGesture() {
        guard let delegate = self.kkDelegate else { return }
        switch self.kkPinchGesture.state {
        case .possible: break
        case .began:
            let location = self.kkPinchGesture.location(in: self)
            let scale = self.kkPinchGesture.scale
            self.kkPreviousPinchLocation = location
            self.kkPreviousPinchScale = scale
            delegate.handle(pinch: .init(
                state: .begin,
                location: Point(location),
                scale: Double(scale)
            ))
        case .changed:
            if self.kkPinchGesture.numberOfTouches != 2 {
                self.kkPinchGesture.isEnabled = false
            } else {
                let location = self.kkPinchGesture.location(in: self)
                let scale = self.kkPinchGesture.scale
                self.kkPreviousPinchLocation = location
                self.kkPreviousPinchScale = scale
                delegate.handle(pinch: .init(
                    state: .change,
                    location: Point(location),
                    scale: Double(scale)
                ))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousPinchLocation, let scale = self.kkPreviousPinchScale {
                self.kkPreviousPinchLocation = nil
                self.kkPreviousPinchScale = nil
                delegate.handle(pinch: .init(
                    state: .end,
                    location: Point(location),
                    scale: Double(scale)
                ))
            }
            self.kkPinchGesture.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handleRotationGesture() {
        guard let delegate = self.kkDelegate else { return }
        switch self.kkRotationGesture.state {
        case .possible: break
        case .began:
            let location = self.kkRotationGesture.location(in: self)
            let angle = self.kkRotationGesture.rotation
            self.kkPreviousRotationLocation = location
            self.kkPreviousRotationAngle = angle
            delegate.handle(rotation: .init(
                state: .begin,
                location: Point(location),
                angle: Angle(radians: Double(angle))
            ))
        case .changed:
            if self.kkRotationGesture.numberOfTouches != 2 {
                self.kkRotationGesture.isEnabled = false
            } else {
                let location = self.kkRotationGesture.location(in: self)
                let angle = self.kkRotationGesture.rotation
                self.kkPreviousRotationLocation = location
                self.kkPreviousRotationAngle = angle
                delegate.handle(rotation: .init(
                    state: .change,
                    location: Point(location),
                    angle: Angle(radians: Double(angle))
                ))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousRotationLocation, let angle = self.kkPreviousRotationAngle {
                self.kkPreviousRotationLocation = nil
                self.kkPreviousRotationAngle = nil
                delegate.handle(rotation: .init(
                    state: .end,
                    location: Point(location),
                    angle: Angle(radians: Double(angle))
                ))
            }
            self.kkRotationGesture.isEnabled = true
        @unknown default: break
        }
    }
    
}

extension KKCanvasView : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        if let found = self.kkTapGestures.first(where: { $0.value === gestureRecognizer }) {
            return delegate.shouldTap(found.key)
        } else if let found = self.kkLongPressGestures.first(where: { $0.value === gestureRecognizer }) {
            return delegate.shouldLongTap(found.key)
        } else if let found = self.kkPanGestures.first(where: { $0.value === gestureRecognizer }) {
            return delegate.shouldPan(found.key)
        } else if gestureRecognizer === self.kkPinchGesture {
            return delegate.shouldPinch()
        } else if gestureRecognizer === self.kkRotationGesture {
            return delegate.shouldRotation()
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard self.kkSimultaneouslyGestures.contains(gestureRecognizer) == true else { return false }
        guard self.kkSimultaneouslyGestures.contains(otherGestureRecognizer) == true else { return false }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.kkTapGestures.first(where: { $0.value === gestureRecognizer }) != nil {
            if self.kkLongPressGestures.first(where: { $0.value === otherGestureRecognizer }) != nil {
                return true
            }
        }
        return false
    }
    
}

#endif
