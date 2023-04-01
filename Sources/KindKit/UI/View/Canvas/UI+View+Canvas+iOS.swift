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
    
    var kkCanvas: IGraphicsCanvas?
    var kkTapGestures: [Graphics.Gesture : UITapGestureRecognizer] = [:]
    var kkLongPressGestures: [Graphics.Gesture : UILongPressGestureRecognizer] = [:]
    var kkPanGestures: [Graphics.Gesture : UIPanGestureRecognizer] = [:]
    var kkPreviousPanLocation: [Graphics.Gesture : CGPoint] = [:]
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
        
        for canvasGesture in Graphics.Gesture.allCases {
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
        if let canvas = self.kkCanvas {
            canvas.resize(Size(self.bounds.size))
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let cgContext = UIGraphicsGetCurrentContext() else { return }
        if let canvas = self.kkCanvas {
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
        self.kkCanvas = canvas
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
        guard let canvas = self.kkCanvas else {
            return
        }
        guard let found = self.kkTapGestures.first(where: { $0.value === gesture }) else {
            return
        }
        let location = found.value.location(in: self)
        canvas.tapGesture(found.key, location: Point(location))
    }
    
    @objc
    func _handleLongPressGesture(_ gesture: UIGestureRecognizer) {
        guard let canvas = self.kkCanvas else {
            return
        }
        guard let found = self.kkTapGestures.first(where: { $0.value === gesture }) else {
            return
        }
        let location = found.value.location(in: self)
        canvas.longTapGesture(found.key, location: Point(location))
    }
    
    @objc
    func _handlePanGesture(_ gesture: UIGestureRecognizer) {
        guard let canvas = self.kkCanvas else {
            return
        }
        guard let found = self.kkPanGestures.first(where: { $0.value === gesture }) else {
            return
        }
        switch found.value.state {
        case .possible: break
        case .began:
            let location = found.value.location(in: self)
            self.kkPreviousPanLocation[found.key] = location
            canvas.beginPanGesture(found.key, location: Point(location))
        case .changed:
            if found.value.numberOfTouches != found.value.minimumNumberOfTouches {
                found.value.isEnabled = false
            } else {
                let location = found.value.location(in: self)
                self.kkPreviousPanLocation[found.key] = location
                canvas.changePanGesture(found.key, location: Point(location))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousPanLocation[found.key] {
                self.kkPreviousPanLocation[found.key] = nil
                canvas.endPanGesture(found.key, location: Point(location))
            }
            found.value.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handlePinchGesture() {
        guard let canvas = self.kkCanvas else {
            return
        }
        switch self.kkPinchGesture.state {
        case .possible: break
        case .began:
            let location = self.kkPinchGesture.location(in: self)
            let scale = self.kkPinchGesture.scale
            self.kkPreviousPinchLocation = location
            self.kkPreviousPinchScale = scale
            canvas.beginPinchGesture(location: Point(location), scale: Double(scale))
        case .changed:
            if self.kkPinchGesture.numberOfTouches != 2 {
                self.kkPinchGesture.isEnabled = false
            } else {
                let location = self.kkPinchGesture.location(in: self)
                let scale = self.kkPinchGesture.scale
                self.kkPreviousPinchLocation = location
                self.kkPreviousPinchScale = scale
                canvas.changePinchGesture(location: Point(location), scale: Double(scale))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousPinchLocation, let scale = self.kkPreviousPinchScale {
                self.kkPreviousPinchLocation = nil
                self.kkPreviousPinchScale = nil
                canvas.endPinchGesture(location: Point(location), scale: Double(scale))
            }
            self.kkPinchGesture.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handleRotationGesture() {
        guard let canvas = self.kkCanvas else {
            return
        }
        switch self.kkRotationGesture.state {
        case .possible: break
        case .began:
            let location = self.kkRotationGesture.location(in: self)
            let angle = self.kkRotationGesture.rotation
            self.kkPreviousRotationLocation = location
            self.kkPreviousRotationAngle = angle
            canvas.beginRotationGesture(location: Point(location), angle: Angle(radians: Double(angle)))
        case .changed:
            if self.kkRotationGesture.numberOfTouches != 2 {
                self.kkRotationGesture.isEnabled = false
            } else {
                let location = self.kkRotationGesture.location(in: self)
                let angle = self.kkRotationGesture.rotation
                self.kkPreviousRotationLocation = location
                self.kkPreviousRotationAngle = angle
                canvas.changeRotationGesture(location: Point(location), angle: Angle(radians: Double(angle)))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousRotationLocation, let angle = self.kkPreviousRotationAngle {
                self.kkPreviousRotationLocation = nil
                self.kkPreviousRotationAngle = nil
                canvas.endRotationGesture(location: Point(location), angle: Angle(radians: Double(angle)))
            }
            self.kkRotationGesture.isEnabled = true
        @unknown default: break
        }
    }
    
}

extension KKCanvasView : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let canvas = self.kkCanvas else {
            return false
        }
        if let found = self.kkTapGestures.first(where: { $0.value === gestureRecognizer }) {
            return canvas.shouldTapGesture(found.key)
        } else if let found = self.kkLongPressGestures.first(where: { $0.value === gestureRecognizer }) {
            return canvas.shouldLongTapGesture(found.key)
        } else if let found = self.kkPanGestures.first(where: { $0.value === gestureRecognizer }) {
            return canvas.shouldPanGesture(found.key)
        } else if gestureRecognizer === self.kkPinchGesture {
            return canvas.shouldPinchGesture()
        } else if gestureRecognizer === self.kkRotationGesture {
            return canvas.shouldRotationGesture()
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
